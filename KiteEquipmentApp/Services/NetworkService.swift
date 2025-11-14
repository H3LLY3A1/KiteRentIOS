//
//  NetworkService.swift
//  KiteEquipmentApp
//
//  Serwis do komunikacji z Supabase backend
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Nieprawidłowy URL"
        case .noData:
            return "Brak danych z serwera"
        case .decodingError:
            return "Błąd dekodowania danych"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Brak autoryzacji"
        }
    }
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    // MARK: - Generic Request Method
    private func makeRequest<T: Decodable>(
        url: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) async throws -> T {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authorization header
        if requiresAuth {
            let token = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.accessToken) ?? ""
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue("Bearer \(Constants.SUPABASE_ANON_KEY)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if present
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        // Check for errors
        if httpResponse.statusCode >= 400 {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.serverError(errorResponse.error)
            }
            throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    // MARK: - Equipment API
    func fetchEquipment() async throws -> [Equipment] {
        try await makeRequest(url: Constants.Endpoints.equipment)
    }
    
    func startUse(equipmentId: String, instructor: String) async throws -> Equipment {
        struct Body: Codable {
            let instructor: String
        }
        
        return try await makeRequest(
            url: Constants.Endpoints.startUse(equipmentId: equipmentId),
            method: "POST",
            body: Body(instructor: instructor)
        )
    }
    
    func endUse(equipmentId: String) async throws -> Equipment {
        try await makeRequest(
            url: Constants.Endpoints.endUse(equipmentId: equipmentId),
            method: "POST"
        )
    }
    
    func createEquipment(name: String, type: String, identifier: String, status: String) async throws -> Equipment {
        struct Body: Codable {
            let name: String
            let type: String
            let identifier: String
            let status: String
        }
        
        return try await makeRequest(
            url: Constants.Endpoints.equipment,
            method: "POST",
            body: Body(name: name, type: type, identifier: identifier, status: status),
            requiresAuth: true
        )
    }
    
    func updateEquipment(id: String, name: String, type: String, status: String) async throws -> Equipment {
        struct Body: Codable {
            let name: String
            let type: String
            let status: String
        }
        
        return try await makeRequest(
            url: Constants.Endpoints.updateEquipment(equipmentId: id),
            method: "PUT",
            body: Body(name: name, type: type, status: status),
            requiresAuth: true
        )
    }
    
    func deleteEquipment(id: String) async throws {
        struct Response: Codable {
            let success: Bool
        }
        
        let _: Response = try await makeRequest(
            url: Constants.Endpoints.deleteEquipment(equipmentId: id),
            method: "DELETE",
            requiresAuth: true
        )
    }
    
    // MARK: - History API
    func fetchHistory() async throws -> [HistoryEntry] {
        try await makeRequest(
            url: Constants.Endpoints.history,
            requiresAuth: true
        )
    }
    
    // MARK: - Auth API
    func login(email: String, password: String) async throws -> String {
        struct Body: Codable {
            let email: String
            let password: String
        }
        
        let response: LoginResponse = try await makeRequest(
            url: Constants.Endpoints.login,
            method: "POST",
            body: Body(email: email, password: password)
        )
        
        return response.accessToken
    }
    
    func signup(email: String, password: String, name: String) async throws -> User {
        struct Body: Codable {
            let email: String
            let password: String
            let name: String
        }
        
        let response: SignupResponse = try await makeRequest(
            url: Constants.Endpoints.signup,
            method: "POST",
            body: Body(email: email, password: password, name: name)
        )
        
        return response.user
    }
}

// MARK: - Helper Models
struct ErrorResponse: Codable {
    let error: String
}
