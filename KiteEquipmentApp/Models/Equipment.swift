//
//  Equipment.swift
//  KiteEquipmentApp
//
//  Model sprzętu
//

import Foundation

struct Equipment: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var type: String
    var identifier: String
    var status: String
    var currentInstructor: String?
    var currentSessionStart: String?
    var currentSessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case identifier
        case status
        case currentInstructor
        case currentSessionStart
        case currentSessionId
    }
    
    // Computed properties
    var statusEnum: Constants.EquipmentStatus {
        Constants.EquipmentStatus(rawValue: status) ?? .available
    }
    
    var isAvailable: Bool {
        status == Constants.EquipmentStatus.available.rawValue
    }
    
    var isInUse: Bool {
        status == Constants.EquipmentStatus.inUse.rawValue
    }
    
    var isInService: Bool {
        status == Constants.EquipmentStatus.service.rawValue
    }
}

// MARK: - Sample Data (for previews)
extension Equipment {
    static let sample = Equipment(
        id: "KITE-001",
        name: "North Rebel 9m",
        type: "Latawiec",
        identifier: "KITE-001",
        status: "wolny"
    )
    
    static let sampleInUse = Equipment(
        id: "KITE-002",
        name: "North Rebel 12m",
        type: "Latawiec",
        identifier: "KITE-002",
        status: "na_zajeciach",
        currentInstructor: "Jan Kowalski",
        currentSessionStart: "2025-01-15T10:30:00Z"
    )
    
    static let sampleService = Equipment(
        id: "BOARD-001",
        name: "TT Boost 135cm",
        type: "Deska",
        identifier: "BOARD-001",
        status: "serwis"
    )
    
    static let samples = [sample, sampleInUse, sampleService]
}
