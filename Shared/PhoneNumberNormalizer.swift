import Foundation

enum PhoneNumberNormalizer {
    static func normalizeCostaRica(_ input: String) -> String? {
        var digits = input.filter(\.isNumber)
        if digits.hasPrefix("00") { digits.removeFirst(2) }
        if digits.count == 8 { digits = "506" + digits }
        guard digits.count == 11, digits.hasPrefix("506") else { return nil }
        return "+" + digits
    }

    static func callKitValue(from normalized: String) -> Int64? {
        Int64(normalized.filter(\.isNumber))
    }

    static func display(_ normalized: String) -> String {
        let digits = normalized.filter(\.isNumber)
        guard digits.count == 11, digits.hasPrefix("506") else { return normalized }
        let local = String(digits.suffix(8))
        return "+506 \(local.prefix(4))-\(local.suffix(4))"
    }
}
