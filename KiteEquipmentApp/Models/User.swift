//
//  User.swift
//  KiteEquipmentApp
//
//  Model użytkownika
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
    }
}

struct LoginResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
    }
}

struct SignupResponse: Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user
    }
}
