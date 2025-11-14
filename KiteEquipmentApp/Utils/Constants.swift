//
//  Constants.swift
//  KiteEquipmentApp
//
//  Stałe używane w aplikacji
//

import Foundation

struct Constants {
    // MARK: - API Configuration
    static let SUPABASE_URL = "https://tjfstsjvuewxnixwwnsk.supabase.co"
    static let SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqZnN0c2p2dWV3eG5peHd3bnNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA3MDA0ODgsImV4cCI6MjA3NjI3NjQ4OH0.JC_8-vScD5GXdZfMxRW2_D2J6ZBjNh50M5RlRby7QAA"
    
    // MARK: - API Endpoints
    static let API_BASE = "\(SUPABASE_URL)/functions/v1/make-server-93b35a19"
    
    struct Endpoints {
        static let login = "\(API_BASE)/auth/login"
        static let signup = "\(API_BASE)/auth/signup"
        static let equipment = "\(API_BASE)/equipment"
        static let history = "\(API_BASE)/history"
        
        static func startUse(equipmentId: String) -> String {
            "\(API_BASE)/equipment/\(equipmentId)/start-use"
        }
        
        static func endUse(equipmentId: String) -> String {
            "\(API_BASE)/equipment/\(equipmentId)/end-use"
        }
        
        static func updateEquipment(equipmentId: String) -> String {
            "\(API_BASE)/equipment/\(equipmentId)"
        }
        
        static func deleteEquipment(equipmentId: String) -> String {
            "\(API_BASE)/equipment/\(equipmentId)"
        }
    }
    
    // MARK: - User Defaults Keys
    struct UserDefaultsKeys {
        static let accessToken = "accessToken"
        static let userRole = "userRole"
    }
    
    // MARK: - Colors
    struct Colors {
        // Status colors
        static let availableColor = "green"
        static let inUseColor = "orange"
        static let serviceColor = "red"
    }
    
    // MARK: - Equipment Types
    static let equipmentTypes = ["Latawiec", "Deska", "Trapez", "Inne"]
    
    // MARK: - Equipment Status
    enum EquipmentStatus: String, CaseIterable {
        case available = "wolny"
        case inUse = "na_zajeciach"
        case service = "serwis"
        
        var displayName: String {
            switch self {
            case .available: return "Wolny"
            case .inUse: return "Na zajęciach"
            case .service: return "Serwis"
            }
        }
        
        var color: String {
            switch self {
            case .available: return Colors.availableColor
            case .inUse: return Colors.inUseColor
            case .service: return Colors.serviceColor
            }
        }
    }
}
