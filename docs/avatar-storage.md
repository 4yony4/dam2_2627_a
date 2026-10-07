# Avatar y Firebase Storage

## Flujo actual

1. `EditProfileView` permite elegir una imagen con la cámara o la galería mediante `image_picker`. Guarda el `XFile` en `ficheroCargado` y presenta una vista previa en `Perfil.avatar`.
2. Al pulsar **Guardar**, si `Perfil.avatar` no es nulo, `Storageadmin.subirAvatar()` comprime el archivo con `flutter_image_compress` (`quality: 35`, ancho mínimo 2300 y alto mínimo 1500).
3. La subida usa `putData` y sobrescribe `usuarios/{uid}/imagenes/avatar.jpg`. La URL de descarga se guarda en `Perfil.urlAvatar`.
4. La vista escribe nombre, edad, altura y `urlAvatar` en `Perfiles/{uid}` con `set(..., merge: true)`. `Perfil.fromFirestore` lee la URL y el constructor crea un `Image.network` cuando existe una URL.

`Dataholder` conserva una instancia de `Storageadmin`. La configuración del bucket procede de la inicialización de Firebase en `main.dart`; `firebase.json` enlaza `storage.rules` y declara el emulador de Storage en el puerto 9199. La llamada a `useStorageEmulator` está comentada, así que la app no usa ese emulador por defecto.

## Limitaciones verificadas en el código

- `clickGuardar` decide subir con `perfil.avatar != null` y después fuerza `ficheroCargado!`. Si el avatar se cargó desde Firestore y no se eligió una foto nueva, ese archivo es nulo.
- La compresión ocurre antes del bloque `try` de `subirAvatar`; el método fuerza `result!`. Si falla la compresión, la excepción sale hacia `clickGuardar` antes de su propio bloque `try` y el botón puede quedar en estado de guardado.
- El bloque de subida captura una excepción de `cloud_firestore`, aunque la operación usa Firebase Storage. No hay confirmación de que gestione errores de Storage como se espera.
- Las reglas actuales de `storage.rules` permiten leer y escribir cualquier ruta hasta el 20 de febrero de 2028. Deben revisarse antes de usar datos reales: el código no limita el acceso a los archivos del propietario.
- La cámara tiene `NSCameraUsageDescription` en iOS. La compatibilidad de cámara, galería y compresión en cada plataforma aún requiere pruebas en dispositivo.

No hay una Cloud Function activa en `functions/index.js`; el archivo contiene únicamente la plantilla comentada.
