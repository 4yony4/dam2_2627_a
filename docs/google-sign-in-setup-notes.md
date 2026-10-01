# Notas temporales: configuración de Google Sign-In

> Documento de trabajo para el paso de documentación. No es documentación final.

## Datos del proyecto

| Dato | Valor |
|---|---|
| Proyecto Firebase | `dam-daw-lm1` (número `892128540697`) |
| App Android | `1:892128540697:android:8956fa4c81c69a5f589288` |
| App Web | `1:892128540697:web:7e689533caed23a1589288` |
| `package_name` / `applicationId` | `com.newton.dam2_2627_a` (coinciden en `google-services.json` y `android/app/build.gradle.kts`) |

## Pasos realizados

1. **ID del proyecto** obtenido de `firebase.json` / `lib/firebase_options.dart`.
   Proyecto activo del MCP de Firebase fijado a `dam-daw-lm1`.
2. **Proveedor Google en Authentication**: consultado con la API de Identity Toolkit
   (`admin/v2/projects/dam-daw-lm1/defaultSupportedIdpConfigs`). Resultado: **vacío → Google NO está habilitado**.
   Solo está activo Email/Contraseña. Hay que activarlo a mano (ver abajo).
3. **Huellas SHA del keystore de debug** (`~/.android/debug.keystore`, alias `androiddebugkey`),
   obtenidas con `keytool -list -v`:
   - SHA-1: `43:70:0B:BC:C5:BC:3D:6D:98:7C:7A:2C:AF:48:12:C2:76:E1:EB:3C`
   - SHA-256: `4F:1C:90:E8:DC:D7:AA:EE:C9:F9:70:1D:B5:1D:21:7A:94:E7:48:58:21:68:34:A9:5A:95:46:32:A5:9E:7D:0C`

   Registradas en la app Android de Firebase con `firebase_create_android_sha` (MCP). Ambas OK.
   > Cada alumno tiene su propio keystore de debug: cada uno debe añadir **sus** SHA en la consola
   > (o con `cd android && ./gradlew signingReport`), si no Google Sign-In falla en Android con `DEVELOPER_ERROR` (código 10).
4. **Dominios autorizados (Web)**: confirmados `localhost`, `dam-daw-lm1.firebaseapp.com`, `dam-daw-lm1.web.app`.
   `localhost` ya viene por defecto, no hay que hacer nada.
5. **Paquete**: `flutter pub add google_sign_in` → `google_sign_in: ^7.2.0` (API v7:
   `GoogleSignIn.instance.initialize(...)` + `GoogleSignIn.instance.authenticate()`). `flutter pub get` OK.
   `flutter analyze`: mismos 101 avisos que antes (todos previos), ninguno nuevo.

## Pasos manuales pendientes (consola de Firebase)

1. Abrir <https://console.firebase.google.com/project/dam-daw-lm1/authentication/providers>.
2. **Authentication → Sign-in method → Añadir proveedor → Google**.
3. Activar el interruptor **Habilitar**.
4. Elegir el **correo de asistencia del proyecto** (support email) en el desplegable.
5. (Opcional) Ajustar el nombre público del proyecto que verá el usuario en la pantalla de consentimiento.
6. **Guardar**. Firebase crea automáticamente el cliente OAuth de tipo *Web* (client_type 3).

## Después de habilitar Google

1. Descargar de nuevo `google-services.json`
   (Configuración del proyecto → Tus apps → Android → `google-services.json`) y sustituir
   `android/app/google-services.json`. Alternativa: `flutterfire configure` o el MCP `firebase_get_sdk_config`.
2. Comprobar que `oauth_client` ya **no está vacío** y contiene una entrada con `"client_type": 3`
   (el *Web client ID*, que en Android se pasa como `serverClientId` a `GoogleSignIn.instance.initialize`).
3. Web: el *Web client ID* (Consola → Authentication → Google → *Configuración del SDK web*) se puede usar
   como `clientId` en `initialize` o en la meta etiqueta `google-signin-client_id` de `web/index.html`.

## Seguridad

- Los *client ID* de OAuth y las huellas SHA son identificadores públicos: se pueden versionar.
- No se versionan contraseñas de keystore, claves privadas ni el *client secret* del cliente web.
