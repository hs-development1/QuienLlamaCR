# Quién Llama CR — v0.4

Aplicación iOS para consultar reputación comunitaria de números de Costa Rica y mantener listas de identificación/bloqueo mediante CallKit Call Directory.

## Cambios de v0.4

- Corrige el error de Swift/Xcode 26 en `withCheckedThrowingContinuation`.
- Corrige la URL del feed remoto para la carpeta `QuienLlamaCR-v0.4`.
- Agrega base local `reputation.json` y fallback sin conexión.
- Agrega `Assets.xcassets` con AppIcon y AccentColor.
- Agrega `PrivacyInfo.xcprivacy`.
- Mantiene App Group `group.cr.quienllama.shared`.
- Mantiene extensión Call Directory embebida.
- Evita duplicados en la lista de bloqueo/identificación.
- Sube versión a `0.4.0` / build `4`.
- Incluye workflow listo para compilar con XcodeGen y crear un IPA sin firma.

## Para GitHub

1. Subí la carpeta completa `QuienLlamaCR-v0.4` al root del repositorio.
2. Copiá `QuienLlamaCR-v0.4/build-ios-v0.4.yml` a:
   `.github/workflows/build-ios.yml`
3. Ejecutá `Build iOS IPA v0.4` desde Actions.

El IPA producido es **sin firma**. La instalación final requiere firma válida para el iPhone y sus extensiones/capabilities.
