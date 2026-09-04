import Foundation

enum SharedBlockStore {
    static let appGroup = "group.cr.quienllama.shared"
    private static let blockedKey = "blockedNumbers"
    private static let identificationKey = "identificationEntries"

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroup) ?? .standard
    }

    static func blockedNumbers() -> [String] {
        defaults.stringArray(forKey: blockedKey) ?? []
    }

    static func setBlockedNumbers(_ numbers: [String]) {
        defaults.set(Array(Set(numbers)).sorted(), forKey: blockedKey)
    }

    static func addBlockedNumber(_ number: String) {
        var values = blockedNumbers()
        values.append(number)
        setBlockedNumbers(values)
    }

    static func removeBlockedNumber(_ number: String) {
        setBlockedNumbers(blockedNumbers().filter { $0 != number })
    }

    static func identificationEntries() -> [IdentificationEntry] {
        guard
            let data = defaults.data(forKey: identificationKey),
            let entries = try? JSONDecoder().decode([IdentificationEntry].self, from: data)
        else { return [] }
        return entries
    }

    static func setIdentificationEntries(_ entries: [IdentificationEntry]) {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: identificationKey)
    }
}
