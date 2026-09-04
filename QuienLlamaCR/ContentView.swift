import SwiftUI

struct ContentView: View {
    @StateObject private var store = ReputationStore()
    @State private var number = ""
    @State private var result: ReputationRecord?
    @State private var actionMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Consultar número de Costa Rica") {
                    TextField("Ej. 8888-1234", text: $number)
                        .keyboardType(.phonePad)

                    Button("Investigar número") {
                        result = store.lookup(number)
                        actionMessage = result == nil
                            ? "Ingresá un número válido de Costa Rica."
                            : ""
                    }

                    Button("Actualizar base comunitaria") {
                        Task {
                            await store.refresh()
                            result = store.lookup(number)
                        }
                    }
                }

                Section("Estado") {
                    Text(store.refreshMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if let result {
                    Section("Resultado") {
                        Label(result.level.title, systemImage: result.level.symbol)
                            .font(.headline)
                        LabeledContent("Número", value: PhoneNumberNormalizer.display(result.phoneNumber))
                        LabeledContent("Categoría", value: result.category)
                        LabeledContent("Reportes", value: "\(result.reports)")
                        LabeledContent("Riesgo", value: "\(result.score)/100")

                        Button("Reportar como spam o fraude") {
                            self.result = store.report(
                                result.phoneNumber,
                                category: "Spam / posible fraude"
                            )
                        }

                        Button("Bloquear este número", role: .destructive) {
                            SharedBlockStore.addBlockedNumber(result.phoneNumber)
                            Task {
                                do {
                                    try await CallDirectoryReloader.reload()
                                    actionMessage = "Número agregado al filtro de llamadas."
                                } catch {
                                    actionMessage = "Guardado. Activá la extensión en Configuración de iOS y recargá el filtro."
                                }
                            }
                        }
                    }
                }

                if !actionMessage.isEmpty {
                    Section {
                        Text(actionMessage)
                    }
                }

                Section("Privacidad y uso") {
                    Text("La reputación se basa en reportes y puntuaciones. Un reporte aislado no debe tratarse como prueba de fraude.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    NavigationLink("Ver números bloqueados") {
                        BlockedNumbersView()
                    }
                }
            }
            .navigationTitle("Quién Llama CR")
        }
    }
}
