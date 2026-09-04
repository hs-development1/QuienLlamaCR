import CallKit
import Foundation

final class CallDirectoryHandler: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        let blocked = SharedBlockStore.blockedNumbers().compactMap(PhoneNumberNormalizer.callKitValue).sorted()
        for number in blocked { context.addBlockingEntry(withNextSequentialPhoneNumber: number) }

        let blockedSet = Set(blocked)
        let identifications = SharedBlockStore.identificationEntries()
            .compactMap { entry -> (Int64, String)? in
                guard let number = PhoneNumberNormalizer.callKitValue(from: entry.phoneNumber), !blockedSet.contains(number) else { return nil }
                return (number, entry.label)
            }
            .sorted { $0.0 < $1.0 }

        var previous: Int64?
        for (number, label) in identifications where previous != number {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: number, label: label)
            previous = number
        }
        context.completeRequest()
    }
}
