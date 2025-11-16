import Foundation
import SwiftUI
import Combine
import PostgresNIO // Wymagane!
import BcryptSwift // Wymagane do bezpiecznej weryfikacji hasła!
import NIO

class DirectAdminLoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var loggedInUser: UserModel?
    
    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    private var connection: PostgresConnection?

    deinit {
        try? eventLoopGroup.syncShutdownGracefully()
    }

    func login(completion: @escaping (Bool) -> Void) {
        
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Proszę podać adres e-mail i hasło."
            completion(false)
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        let config = PostgresConnection.Configuration(
            host: Constants.Database.host,
            port: Constants.Database.port,
            database: Constants.Database.database,
            username: Constants.Database.user,
            password: Constants.Database.password
        )
        
        let query = Constants.Queries.getAdminDataByEmail(email: email)
        
        PostgresConnection.connect(using: config, on: eventLoopGroup)
            .flatMap { connection -> EventLoopFuture<PostgresConnection.RowStream> in
                
                self.connection = connection 
                
                return connection.query(query)
            }
            .whenComplete { result in
                
                defer { self.connection?.close().whenFailure { error in print("Błąd zamykania połączenia: \(error)") } }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch result {
                    case .success(let rowStream):
                        rowStream.collect().whenSuccess { rows in
                            guard let row = rows.first else {
                                self.errorMessage = "Użytkownik o tym e-mailu nie istnieje."
                                completion(false)
                                return
                            }
                            
                            do {
                                let passwordHash = try row.decode(String.self, at: 3)
                                let user = UserModel(
                                    id: try row.decode(Int.self, at: 0),
                                    email: try row.decode(String.self, at: 1),
                                    role: try row.decode(String.self, at: 2),
                                    passwordHash: passwordHash
                                )
                                
                                if try BcryptSwift.verify(self.password, hash: user.passwordHash) {
                                    
                                    self.loggedInUser = user
                                    UserDefaults.standard.set(user.email, forKey: Constants.UserDefaultsKeys.loggedInAdminEmail)
                                    UserDefaults.standard.set(user.role, forKey: Constants.UserDefaultsKeys.userRole)
                                    completion(true)
                                    
                                } else {
                                    self.errorMessage = "Nieprawidłowe hasło."
                                    completion(false)
                                }
                                
                            } catch {
                                self.errorMessage = "Błąd: Nieprawidłowa struktura danych użytkownika lub haszowanie."
                                completion(false)
                            }
                        }
                        
                    case .failure(let error):
                        self.errorMessage = "Błąd serwera/bazy danych: \(error.localizedDescription)"
                        completion(false)
                    }
                }
            }
    }
}
