import Foundation

enum ReputationLevel: String, Codable {
    case verified, unknown, suspicious, dangerous

    var title: String {
        switch self {
        case .verified: return "Verificado"
        case .unknown: return "Sin referencias suficientes"
        case .suspicious: return "Sospechoso"
        case .dangerous: return "Alto riesgo"
        }
    }

    var symbol: String {
        switch self {
        case .verified: return "checkmark.shield.fill"
        case .unknown: return "questionmark.circle"
        case .suspicious: return "exclamationmark.triangle.fill"
        case .dangerous: return "hand.raised.fill"
        }
    }
}

struct ReputationRecord: Codable, Identifiable, Hashable {
    let phoneNumber: String
    var score: Int
    var category: String
    var reports: Int
    var verified: Bool

    var id: String { phoneNumber }

    var level: ReputationLevel {
        if verified { return .verified }
        if score >= 80 { return .dangerous }
        if score >= 50 { return .suspicious }
        return .unknown
    }
}

struct IdentificationEntry: Codable, Hashable {
    let phoneNumber: String
    let label: String
}
