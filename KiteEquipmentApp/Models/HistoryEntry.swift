//
//  HistoryEntry.swift
//  KiteEquipmentApp
//
//  Model wpisu historii użycia sprzętu
//

import Foundation

struct HistoryEntry: Identifiable, Codable {
    let id: String
    let equipmentId: String
    let equipmentName: String
    let equipmentType: String
    let instructor: String
    let startTime: String
    let endTime: String?
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case equipmentId
        case equipmentName
        case equipmentType
        case instructor
        case startTime
        case endTime
        case date
    }
    
    // Computed properties
    var startDate: Date? {
        ISO8601DateFormatter().date(from: startTime)
    }
    
    var endDate: Date? {
        guard let endTime = endTime else { return nil }
        return ISO8601DateFormatter().date(from: endTime)
    }
    
    var duration: TimeInterval? {
        guard let start = startDate, let end = endDate else { return nil }
        return end.timeIntervalSince(start)
    }
    
    var durationString: String {
        guard let duration = duration else { return "W użyciu" }
        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes)min"
        }
    }
    
    var formattedStartTime: String {
        guard let date = startDate else { return startTime }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var formattedDate: String {
        guard let date = startDate else { return self.date }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Sample Data
extension HistoryEntry {
    static let sample = HistoryEntry(
        id: "1",
        equipmentId: "KITE-001",
        equipmentName: "North Rebel 9m",
        equipmentType: "Latawiec",
        instructor: "Jan Kowalski",
        startTime: "2025-01-15T10:00:00Z",
        endTime: "2025-01-15T12:30:00Z",
        date: "2025-01-15"
    )
    
    static let samples = [
        sample,
        HistoryEntry(
            id: "2",
            equipmentId: "BOARD-001",
            equipmentName: "TT Boost 135cm",
            equipmentType: "Deska",
            instructor: "Anna Nowak",
            startTime: "2025-01-15T11:00:00Z",
            endTime: "2025-01-15T13:00:00Z",
            date: "2025-01-15"
        ),
        HistoryEntry(
            id: "3",
            equipmentId: "KITE-002",
            equipmentName: "North Rebel 12m",
            equipmentType: "Latawiec",
            instructor: "Piotr Wiśniewski",
            startTime: "2025-01-15T14:00:00Z",
            endTime: nil,
            date: "2025-01-15"
        )
    ]
}
