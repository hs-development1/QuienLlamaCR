import SwiftUI

struct BlockedNumbersView: View {
    @State private var numbers = SharedBlockStore.blockedNumbers()
    @State private var message = ""

    var body: some View {
        List {
            if numbers.isEmpty {
                ContentUnavailableView(
                    "Sin números bloqueados",
                    systemImage: "phone",
                    description: Text("Los números que bloqueés aparecerán aquí.")
                )
            } else {
                ForEach(numbers, id: \.self) { number in
                    HStack {
                        Text(PhoneNumberNormalizer.display(number))
                        Spacer()
                        Button("Quitar", role: .destructive) {
                            SharedBlockStore.removeBlockedNumber(number)
                            numbers = SharedBlockStore.blockedNumbers()
                            Task { try? await CallDirectoryReloader.reload() }
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }

            if !message.isEmpty {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Bloqueados")
        .toolbar {
            Button("Recargar filtro") {
                Task {
                    do {
                        try await CallDirectoryReloader.reload()
                        message = "Filtro recargado."
                    } catch {
                        message = "No se pudo recargar. Revisá que la extensión esté activada en iOS."
                    }
                }
            }
        }
    }
}
