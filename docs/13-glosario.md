# 📖 Glosario

> [⬅ Índice de guías](README.md) · [🏠 README principal](../README.md)

![Glosario](img/ilustraciones/13-glosario.jpg)

Las palabras técnicas que aparecen en las guías, explicadas en una o dos frases y con una
analogía cuando ayuda. Cada término indica **dónde lo ves en este proyecto**.

> 💡 Usa `Ctrl+F` / `Cmd+F` para buscar una palabra. Las letras de abajo te llevan a cada sección.

[Dart y Flutter](#dart-y-flutter) · [Firebase y datos](#firebase-y-datos) ·
[Seguridad y login](#seguridad-y-login) · [Red y APIs](#red-y-apis) ·
[Servidor y notificaciones](#servidor-y-notificaciones) · [Pagos](#pagos) ·
[Android nativo y NFC](#android-nativo-y-nfc)

---

## Dart y Flutter

### <a id="widget"></a>Widget
Cada pieza de la interfaz en Flutter (un texto, un botón, una pantalla entera). Las pantallas son
widgets que contienen otros widgets, como piezas de LEGO.

### <a id="statefulwidget"></a>StatefulWidget
Widget con **estado**: datos que cambian (lo que escribe el usuario, una lista que llega de
Firestore). Al llamar a `setState` se vuelve a dibujar. Casi todas las pantallas de `lib/views/` lo son.

### <a id="initstate"></a>initState
Método que Flutter ejecuta **una sola vez** al crear un StatefulWidget. Es el sitio para arrancar
listeners o descargas, al contrario que `build()`, que se ejecuta en cada repintado.

### <a id="futurebuilder"></a>FutureBuilder
Widget que dibuja una cosa mientras un `Future` está pendiente (un "cargando…") y otra cuando
termina. Aquí: `HomeProfileGate`.

### <a id="late"></a>late
Palabra de Dart que promete "le daré valor antes de usarla". Si se lee antes, la app lanza
`LateInitializationError`. Aquí: `Dataholder.perfilUsuario`.

### <a id="ruta"></a>Ruta
Nombre de una pantalla (`"/HomeView"`) registrado en `MiApp.dart` para navegar sin conocer su clase
([02](02-navegacion-y-pantallas.md)).

### <a id="navigator"></a>Navigator
El "montón de cartas" de pantallas de Flutter: `pushNamed` pone una encima, `pop` quita la de arriba,
`popAndPushNamed` cambia la de arriba por otra.

### <a id="badge"></a>Badge
El circulito con un número sobre un icono (p. ej. mensajes sin leer en la barra inferior).

### <a id="tema"></a>Tema
`ThemeData`: colores, tipografía y estilos de botones definidos **una vez** para toda la app
([12](12-tema-y-estilos.md)).

### <a id="colorscheme"></a>ColorScheme
Parte del tema con los colores con nombre (`primary`, `surface`, `error`…) que usan los widgets de Material.

### <a id="capa"></a>Capa
Grupo de clases con la misma responsabilidad (pantallas, estado, Admins, modelos). Cada capa solo
habla con la de al lado ([01](01-arquitectura.md)).

### <a id="modelo"></a>Modelo
Clase que representa un dato del mundo real (`Perfil`, `Mensaje`, `Earthquake`) y sabe convertirse
desde/hacia Firestore o JSON.

### <a id="singleton"></a>Singleton
Clase de la que solo existe **un objeto** en toda la app. Es como la mochila compartida del grupo:
todos meten y sacan cosas de la misma. Aquí: `Dataholder.instance` ([01](01-arquitectura.md)).

### <a id="future-y-await"></a>Future y await
Un `Future` es una promesa de un valor que llegará más tarde (como el ticket de un pedido).
`await` espera a que llegue sin bloquear la pantalla. Aquí: casi todo lo que habla con Firebase.

### <a id="stream"></a>Stream
Un "grifo" de datos: en vez de un valor, llegan **muchos a lo largo del tiempo** (posiciones GPS,
cambios en Firestore). Te suscribes con `.listen(...)`. Aquí: `GPSAdmin.realTimePosition` ([06](06-mapa-gps.md)).

### <a id="callback"></a>Callback
Una función que le pasas a otra para que **te avise** cuando pase algo ("llámame cuando acabes").
Aquí: `onPushReceived`, `onDetailsViewed`, `funLambdaGPS`.

### <a id="listener"></a>Listener
Un callback que se queda **escuchando** un Stream o un evento hasta que lo canceles.
Aquí: el listener de mensajes de `Perfil.descargarMensajes` ([03](03-firestore-modelo-datos.md)).

### <a id="permiso"></a>Permiso
Autorización que el sistema pide al usuario (ubicación, cámara, notificaciones, NFC). Se declara en
`AndroidManifest.xml` / `Info.plist` y, a veces, también se pide en tiempo de ejecución.

### <a id="compresion"></a>Compresión
Reducir el tamaño de un archivo (aquí, la foto del avatar) para subir menos datos. Aquí:
`FlutterImageCompress` en `StorageAdmin` ([05](05-storage-avatar.md)).

## Firebase y datos

### <a id="coleccion"></a>Colección
"Carpeta" de Firestore que contiene documentos del mismo tipo. Aquí: `Perfiles`, `POIs`, `Textos`.

### <a id="documento"></a>Documento
"Ficha" dentro de una colección, con un ID y unos campos (`name`, `edad`…). Aquí: `Perfiles/{uid}`.

### <a id="subcoleccion"></a>Subcolección
Colección que vive **dentro de un documento**. Aquí: `Perfiles/{uid}/Mensajes` y `Perfiles/{uid}/Transactions`.

### <a id="timestamp"></a>Timestamp
Tipo de fecha y hora de Firestore. Aquí: `Mensaje.enviado`.

### <a id="indice"></a>Índice
Estructura que Firestore necesita para consultas que filtran u ordenan por **varios campos** a la vez.
Se declaran en `firestore.indexes.json`.

### <a id="firestore"></a>Firestore
Base de datos NoSQL de Firebase organizada en **colecciones** (carpetas) y **documentos** (fichas con
campos). Aquí: `Perfiles`, `Mensajes`, `POIs`… ([03](03-firestore-modelo-datos.md)).

### <a id="storage"></a>Storage
"Disco duro" en la nube de Firebase para **archivos** (fotos, PDFs). Firestore guarda datos;
Storage guarda ficheros. Aquí: el avatar en `usuarios/{uid}/imagenes/avatar.jpg`.

### <a id="reglas-de-seguridad"></a>Reglas de seguridad
Archivo (`firestore.rules`, `storage.rules`) que decide **quién puede leer o escribir qué** en el
servidor. Es la única protección real: el código de la app se puede saltar.

### <a id="geopoint"></a>GeoPoint
Tipo de dato de Firestore con latitud y longitud. Aquí: `Perfiles.gpsPosition`, `POIs.geoloc`.

## Seguridad y login

### <a id="autenticacion"></a>Autenticación
Comprobar **quién eres** (login). Firebase Authentication lo hace por nosotros con email, Google o
Apple ([04](04-autenticacion.md)).

### <a id="proveedor"></a>Proveedor
Cada forma de iniciar sesión (email/contraseña, Google, Apple). Hay que **activarlo** en la consola de Firebase.

### <a id="credencial"></a>Credencial
El "justificante" que un proveedor (p. ej. Google) entrega para que Firebase te deje entrar:
`GoogleAuthProvider.credential(idToken: …)`.

### <a id="token"></a>Token
Cadena de texto que funciona como **pase temporal**: demuestra quién eres o a qué dispositivo
enviar algo, sin repetir la contraseña.

### <a id="id-token"></a>ID token
Token de Firebase Auth que prueba que un usuario ha iniciado sesión. Se envía a las Cloud Functions
en la cabecera `Authorization: Bearer <ID_TOKEN>` ([08](08-cloud-functions-python.md)).

### <a id="oauth"></a>OAuth
Estándar que permite entrar con una cuenta de otro servicio (Google) **sin dar tu contraseña** a
nuestra app.

### <a id="sha"></a>Huella SHA
"Huella dactilar" del certificado con el que se firma la app Android. Google Sign-In la exige: cada
alumno debe registrar la suya (`cd android && ./gradlew signingReport`).

### <a id="clave-publicable"></a>Clave publicable
Clave que **puede ir en la app** (empieza por `pk_`). Solo sirve para identificarse ante Stripe, no para cobrar.

### <a id="clave-secreta"></a>Clave secreta
Clave que **nunca** va en la app (empieza por `sk_`). Vive en el servidor (Secret Manager). Quien la
tiene puede cobrar y devolver dinero.

### <a id="secret-manager"></a>Secret Manager
Caja fuerte de Google Cloud para guardar claves. Las Functions las leen sin que aparezcan en el
código: `firebase functions:secrets:set NOMBRE`.

## Red y APIs

### <a id="http"></a>HTTP
El protocolo con el que se habla en la web: el cliente hace una **petición** (GET, POST…) a una URL
y el servidor devuelve una **respuesta** con un código (200 OK, 400 error del cliente, 500 error del servidor).

### <a id="api-rest"></a>API REST
Un servidor que ofrece datos a través de URLs con parámetros. Aquí: la API de terremotos del USGS
([07](07-api-http-terremotos.md)).

### <a id="json"></a>JSON
Formato de texto para datos: `{"clave": valor}` y listas `[…]`. Dart lo convierte en `Map` y `List`
con `json.decode`.

### <a id="geojson"></a>GeoJSON
JSON con forma estándar para datos geográficos. Ojo: las coordenadas van **[longitud, latitud]**, al revés de lo habitual.

## Servidor y notificaciones

### <a id="serverless"></a>Serverless
Escribes funciones y la nube se encarga del servidor: se **arrancan solas** cuando hace falta y
pagas por uso. Aquí: Cloud Functions en Python ([08](08-cloud-functions-python.md)).

### <a id="trigger"></a>Trigger
El evento que dispara una función: una petición HTTP, un documento nuevo en Firestore… Es el
"timbre" que despierta a la función.

### <a id="callable"></a>Callable
Cloud Function pensada para llamarse **desde la app** con `FirebaseFunctions.instance.httpsCallable(...)`.
Firebase añade automáticamente el usuario que llama (`req.auth`).

### <a id="haversine"></a>Haversine
Fórmula para calcular la **distancia sobre la esfera terrestre** entre dos puntos (lat, lon). Aquí:
`distancia_km` decide qué móviles están dentro del radio.

### <a id="fcm"></a>FCM
Firebase Cloud Messaging: el "cartero" de Google que entrega **notificaciones push** a los
dispositivos ([09](09-notificaciones-push-fcm.md)).

### <a id="token-de-dispositivo"></a>Token de dispositivo
La "dirección postal" de una instalación de la app para FCM. Aquí se guarda en `Perfiles.sTokenMovil`.

### <a id="apns"></a>APNs
El servicio de notificaciones de Apple. FCM lo usa por debajo en iOS; necesita una clave APNs subida a Firebase.

### <a id="vapid"></a>VAPID
Clave que necesita la web para recibir push con FCM (`getToken(vapidKey: …)`).

### <a id="service-worker"></a>Service worker
Script que el navegador ejecuta en segundo plano; en web es quien recibe las push con la página cerrada
(`firebase-messaging-sw.js`).

### <a id="webhook"></a>Webhook
Una URL de **tu** servidor a la que otro servicio llama cuando pasa algo. Es Stripe "llamándote por
teléfono" cuando el pago termina ([10](10-pagos-stripe.md)).

## Pagos

### <a id="paymentintent"></a>PaymentIntent
"Intención de pago" creada en el servidor de Stripe con un importe y una moneda. Sigue su estado
(pendiente, completado, fallido).

### <a id="clientsecret"></a>clientSecret
Llave de un solo uso de un PaymentIntent que el servidor entrega a la app para que **ese** pago se
pueda completar en el móvil.

### <a id="paymentsheet"></a>PaymentSheet
La hoja de pago ya hecha por Stripe que aparece desde abajo para meter la tarjeta.

## Android nativo y NFC

### <a id="intent"></a>Intent
"Mensaje" de Android que dice **qué ha pasado o qué se quiere hacer** (abrir una app, se ha detectado
un tag…). Android busca qué actividad puede atenderlo.

### <a id="intent-filter"></a>Intent filter
Declaración en `AndroidManifest.xml` que dice "mi actividad atiende estos intents" (p. ej. `TECH_DISCOVERED`).

### <a id="singletop"></a>singleTop
Modo de lanzamiento: si la actividad ya está arriba, **no se crea otra**; el nuevo intent llega por
`onNewIntent` ([11](11-nfc.md)).

### <a id="methodchannel"></a>MethodChannel
"Teléfono" entre Dart y el código nativo (Kotlin/Swift): uno llama a un método por nombre y el otro
responde. Aquí: el canal `nfc_launch`.

### <a id="nfc"></a>NFC
Comunicación inalámbrica de muy corto alcance (unos centímetros): pagos contactless, tarjetas de
transporte, pegatinas.

### <a id="tag"></a>Tag
Chip NFC pasivo (pegatina, tarjeta, llavero) que el móvil alimenta y lee al acercarlo.

### <a id="uid"></a>UID
"Identificador único". En este proyecto aparece con dos significados:
- **uid de Firebase Auth**: el identificador de cada usuario (`FirebaseAuth.instance.currentUser!.uid`),
  usado como ID del documento `Perfiles/{uid}`.
- **UID de un tag NFC**: su número de serie, que mostramos en hexadecimal, p. ej. `04A1B2C3`.

### <a id="ndef"></a>NDEF
Formato estándar para guardar datos (un enlace, un texto) dentro de un tag. Si un tag lleva un
enlace, Android puede abrir el navegador en lugar de nuestra app.
