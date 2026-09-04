import CallKit
import Foundation

final class CallDirectoryHandler: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        let blocked = SharedBlockStore.blockedNumbers()
            .compactMap(PhoneNumberNormalizer.callKitValue)
            .sorted()

        var previousBlocked: Int64?
        for number in blocked where previousBlocked != number {
            context.addBlockingEntry(withNextSequentialPhoneNumber: number)
            previousBlocked = number
        }

        let blockedSet = Set(blocked)
        let identifications = SharedBlockStore.identificationEntries()
            .compactMap { entry -> (Int64, String)? in
                guard
                    let number = PhoneNumberNormalizer.callKitValue(from: entry.phoneNumber),
                    !blockedSet.contains(number)
                else { return nil }
                return (number, entry.label)
            }
            .sorted { $0.0 < $1.0 }

        var previousIdentification: Int64?
        for (number, label) in identifications where previousIdentification != number {
            context.addIdentificationEntry(
                withNextSequentialPhoneNumber: number,
                label: label
            )
            previousIdentification = number
        }

        context.completeRequest()
    }
}
