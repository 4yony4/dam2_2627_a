---
name: probar-en-movil
description: Ayuda, en español, a ejecutar y probar la app dam2_2627_a en un móvil Android real o emulador — flutter run, logcat filtrado, simular eventos con adb (NFC, notificaciones), capturas de pantalla y errores típicos. Úsala cuando un alumno quiera comprobar que algo funciona en el dispositivo o no vea sus print().
---

# Probar en el móvil

## 1. Comprobar el dispositivo

```bash
flutter devices          # ¿aparece el móvil?
adb devices              # debe decir "device" (no "unauthorized": acepta el aviso en el móvil)
```

## 2. Ejecutar

```bash
flutter run              # hot reload con "r", hot restart con "R"
```

> ⚠️ Cambios en `AndroidManifest.xml`, Kotlin (`MainActivity.kt`), `build.gradle` o recursos `res/`
> **no** se aplican con hot reload: para y vuelve a lanzar `flutter run`.

## 3. Ver los mensajes

```bash
adb logcat -s flutter            # solo los print() de Dart
adb logcat -s flutter NFC        # + los Log.d("NFC", …) de Kotlin
adb logcat -c                    # vaciar el log antes de una prueba
```

## 4. Simular eventos

| Qué | Comando | Resultado esperado |
|---|---|---|
| Abrir la app como si se acercara un tag NFC | `adb shell am start -a android.nfc.action.TECH_DISCOVERED -n com.newton.dam2_2627_a/.MainActivity` | `HE LEIDO LA TAG (app abierta por NFC):` (UID vacío porque no hay tag real). Ver `docs/11-nfc.md` |
| Cerrar la app del todo | `adb shell am force-stop com.newton.dam2_2627_a` | |
| Captura de pantalla | `adb exec-out screencap -p > captura.png` | Revisa que no salgan datos personales antes de compartirla |

Las notificaciones push se prueban desde la consola de Firebase (Messaging → mensaje de prueba con
el token que imprime `mostrarToken()`) o con Postman: ver `docs/09-notificaciones-push-fcm.md` y
`docs/08-cloud-functions-python.md`.

## 5. Errores típicos

| Síntoma | Causa probable |
|---|---|
| Pantalla negra al abrir | Una excepción en `main()` antes de `runApp` (mira `adb logcat -s flutter`) |
| Google Sign-In `DEVELOPER_ERROR` (10) | Falta tu SHA-1 de debug en Firebase (`cd android && ./gradlew signingReport`) — `docs/04-autenticacion.md` |
| Al acercar un tag se abre otra app | El tag tiene un enlace (NDEF) que reclama el navegador — `docs/11-nfc.md` |
| No pide permiso de ubicación | Permisos en el manifest o el GPS del móvil apagado — `docs/06-mapa-gps.md` |
