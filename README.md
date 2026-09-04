# Quién Llama CR — v0.4

Este paquete está listo para colocarse DIRECTAMENTE en la raíz del repositorio GitHub.

## Estructura correcta

```text
.github/
  workflows/
    build-ios.yml
CallDirectoryExtension/
  CallDirectoryHandler.swift
Configuration/
  App-Info.plist
  App.entitlements
  CallDirectory-Info.plist
  CallDirectory.entitlements
  PrivacyInfo.xcprivacy
Data/
  reputation.json
QuienLlamaCR/
  BlockedNumbersView.swift
  ContentView.swift
  QuienLlamaCRApp.swift
  ReputationStore.swift
Resources/
  Assets.xcassets/
Shared/
  PhoneNumberNormalizer.swift
  ReputationModels.swift
  SharedBlockStore.swift
.gitignore
project.yml
README.md
```

No debe existir una carpeta `QuienLlamaCR-v0.4` dentro del repositorio.
No debe existir otro workflow dentro del proyecto.
El workflow trabaja desde la raíz del repositorio.
