# Quién Llama CR

MVP iOS para consultar reputación de números de Costa Rica y alimentar una extensión Call Directory.

## Incluye
- SwiftUI.
- Números +506.
- Base comunitaria JSON.
- Lista personal de bloqueo.
- CallKit Call Directory Extension.
- App Group.
- GitHub Actions para generar un IPA sin Mac local.

## Importante
iOS no permite consultar Internet desde la extensión justo al entrar una llamada. La base debe actualizarse y cargarse previamente.

## Compilar desde iPhone
1. Actions > Build iOS IPA.
2. Run workflow.
3. Descargá el artefacto `QuienLlamaCR-unsigned-ipa`.
4. El IPA debe firmarse antes de instalarlo en iPhone.

## Privacidad
Los reportes son señales de reputación, no pruebas de delito. La base comienza vacía.

## Estado
v0.2
