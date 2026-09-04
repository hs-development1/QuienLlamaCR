import Foundation
import CallKit

@MainActor
final class ReputationStore: ObservableObject {
    @Published private(set) var records: [String: ReputationRecord] = [:]
    @Published var refreshMessage = "Base local lista"

    private let feedURL = URL(
        string: "https://raw.githubusercontent.com/hs-development1/QuienLlamaCR/main/QuienLlamaCR-v0.4/Data/reputation.json"
    )!

    init() {
        loadBundledDatabase()
        Task { await refresh() }
    }

    func lookup(_ input: String) -> ReputationRecord? {
        guard let normalized = PhoneNumberNormalizer.normalizeCostaRica(input) else { return nil }
        return records[normalized] ?? ReputationRecord(
            phoneNumber: normalized,
            score: 0,
            category: "Sin clasificar",
            reports: 0,
            verified: false
        )
    }

    @discardableResult
    func report(_ input: String, category: String = "Reporte comunitario") -> ReputationRecord? {
        guard let normalized = PhoneNumberNormalizer.normalizeCostaRica(input) else { return nil }
        var record = records[normalized] ?? ReputationRecord(
            phoneNumber: normalized,
            score: 0,
            category: category,
            reports: 0,
            verified: false
        )

        record.reports += 1
        record.score = min(100, record.score + 15)
        record.category = category
        records[normalized] = record
        syncIdentificationList()
        return record
    }

    func refresh() async {
        do {
            let (data, response) = try await URLSession.shared.data(from: feedURL)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                refreshMessage = "No se pudo actualizar; usando datos locales"
                return
            }

            let decoded = try JSONDecoder().decode([ReputationRecord].self, from: data)
            apply(decoded)
            refreshMessage = "Base actualizada"
        } catch {
            refreshMessage = "Sin conexión con la base; usando datos locales"
        }
    }

    private func loadBundledDatabase() {
        guard
            let url = Bundle.main.url(forResource: "reputation", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode([ReputationRecord].self, from: data)
        else { return }

        apply(decoded)
    }

    private func apply(_ decoded: [ReputationRecord]) {
        let sanitized = decoded.compactMap { record -> ReputationRecord? in
            guard let normalized = PhoneNumberNormalizer.normalizeCostaRica(record.phoneNumber) else { return nil }
            var copy = record
            copy.score = min(100, max(0, copy.score))
            copy.reports = max(0, copy.reports)
            return ReputationRecord(
                phoneNumber: normalized,
                score: copy.score,
                category: copy.category,
                reports: copy.reports,
                verified: copy.verified
            )
        }

        records = Dictionary(uniqueKeysWithValues: sanitized.map { ($0.phoneNumber, $0) })
        syncIdentificationList()
    }

    private func syncIdentificationList() {
        let entries = records.values
            .filter { $0.level == .dangerous || $0.level == .suspicious }
            .map {
                IdentificationEntry(
                    phoneNumber: $0.phoneNumber,
                    label: $0.level == .dangerous ? "Posible fraude/spam" : "Número reportado"
                )
            }
        SharedBlockStore.setIdentificationEntries(entries)
    }
}

enum CallDirectoryReloader {
    static let extensionIdentifier = "cr.quienllama.app.CallDirectoryExtension"

    static func reload() async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in

            CXCallDirectoryManager.sharedInstance.reloadExtension(
                withIdentifier: extensionIdentifier
            ) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
