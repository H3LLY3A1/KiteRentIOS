import Foundation

struct Constants {

    struct Database {
        static let host = "kiteapp-db.cjy06esawu7e.eu-west-3.rds.amazonaws.com"
        static let database = "kiteapp-db"
        static let user = "postgres"
        static let password = "bMZ3SC8RhXlFLPO5LtEy"
        static let port: Int = 5432
    }

    struct UserDefaultsKeys {
        static let loggedInAdminEmail = "loggedInAdminEmail"
        static let userRole = "userRole" 
    }

    struct Colors {
        static let availableColor = "green"
        static let inUseColor = "orange"
        static let serviceColor = "red"
    }

    static let equipmentTypes = ["Latawiec", "Deska", "Trapez", "Inne"]

    enum EquipmentStatus: String, CaseIterable {
        case available = "wolna"   
        case inUse = "zajeta"
        case service = "niedostepny"

        var displayName: String {
            switch self {
            case .available: return "Wolny"
            case .inUse: return "Zajęty"
            case .service: return "Niedostepny"
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

    struct Queries {
        static let getAllKites = "SELECT id, nazwa, status FROM kites;"
        static let getAllInstructors = "SELECT id, imie, nazwisko, telefon FROM instructors;"
        static let getAllRentals = "SELECT id, kite_id, instructor_id, start_time, end_time FROM rentals;"

        static func insertRental(kiteId: Int, instructorId: Int, startTime: String, endTime: String) -> String {
            """
            INSERT INTO rentals (kite_id, instructor_id, start_time, end_time)
            VALUES (\(kiteId), \(instructorId), '\(startTime)', '\(endTime)');
            """
        }

        static func updateKiteStatus(kiteId: Int, status: EquipmentStatus) -> String {
            "UPDATE kites SET status = '\(status.rawValue)' WHERE id = \(kiteId);"
        }

        static func getAdminByEmail(email: String) -> String {
            "SELECT id, email, role FROM users WHERE email = '\(email)';"
        }

        static func getAdminDataByEmail(email: String) -> String {
            "SELECT id, email, role, password_hash FROM users WHERE email = '\(email)';"
        }
    }
}
