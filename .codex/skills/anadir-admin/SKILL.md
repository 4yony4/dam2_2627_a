---
name: anadir-admin
description: Receta guiada, en español, para añadir una nueva clase XxxAdmin al proyecto dam2_2627_a siguiendo su patrón (una clase por servicio en lib/Admins/, registrada en el singleton Dataholder, iniciada en el sitio correcto y documentada). Úsala cuando un alumno quiera integrar un servicio nuevo (sensor, API, plugin, servicio de Firebase…).
---

# Añadir un nuevo Admin

El proyecto organiza cada servicio externo en una clase `XxxAdmin` dentro de `lib/Admins/`
(`FirebaseAdmin`, `GPSAdmin`, `FCMAdmin`, `NFCAdmin`…). Todas cuelgan del singleton
`Dataholder.instance`, así cualquier pantalla las usa sin crear copias.
Lee `docs/01-arquitectura.md` (sección del patrón Admin) antes de empezar.

Guía al alumno paso a paso; pregunta antes de escribir cada archivo y explica el porqué de cada paso.

## Pasos

1. **Dependencia** — si hace falta un paquete: `flutter pub add <paquete>`. Revisa en pub.dev
   plataformas soportadas y permisos.
2. **Clase** — crea `lib/Admins/<Nombre>Admin.dart` con la clase `<Nombre>admin` (estilo del
   proyecto: primera letra mayúscula y el resto en minúscula, p. ej. `Nfcadmin`). Métodos en
   español (`iniciar()`, `leer…()`, `enviar…()`), comentarios `///` didácticos.
3. **Registro** — en `lib/DataHolder.dart` añade el import y el campo:
   `<Nombre>admin <nombre>admin = <Nombre>admin();`
4. **Arranque** — decide dónde se inicia:
   - Algo que debe existir desde el principio y no depende de la UI → `lib/main.dart`, **antes de
     `runApp` solo si no puede lanzar excepciones** (lección del caso del FCM en `docs/09-notificaciones-push-fcm.md`).
   - Algo que depende de una pantalla → `initState` de esa vista.
   - **Nunca** en un `build()`: se ejecuta en cada repintado (ver `initGPSUpdate` en `docs/06-mapa-gps.md`).
5. **Permisos / plataforma** — `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`.
   Si solo funciona en una plataforma, protégelo como en `NFCAdmin.iniciar()`
   (`kIsWeb || defaultTargetPlatform != TargetPlatform.android`).
6. **Probar** — usa la habilidad `probar-en-movil`.
7. **Documentar** — crea `docs/NN-<tema>.md` con la plantilla de las otras guías, añádela a
   `docs/README.md` y al índice del `README.md`, y ejecuta `documentar-cambios`.
