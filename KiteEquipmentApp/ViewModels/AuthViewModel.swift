//
//  AuthViewModel.swift
//  KiteEquipmentApp
//
//  ViewModel dla autentykacji
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var accessToken: String?
    
    private let networkService = NetworkService.shared
    
    func checkSession() {
        if let token = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.accessToken),
           !token.isEmpty {
            self.accessToken = token
            self.isAuthenticated = true
        }
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let token = try await networkService.login(email: email, password: password)
            
            // Save token
            UserDefaults.standard.set(token, forKey: Constants.UserDefaultsKeys.accessToken)
            UserDefaults.standard.set("admin", forKey: Constants.UserDefaultsKeys.userRole)
            
            self.accessToken = token
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.userRole)
        
        self.accessToken = nil
        self.isAuthenticated = false
    }
}
