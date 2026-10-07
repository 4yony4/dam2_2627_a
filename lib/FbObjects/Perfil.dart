// =====================================================================
// Perfil.dart — MODELO DEL PERFIL DEL USUARIO (Y SUS MENSAJES)
// ---------------------------------------------------------------------
// Representa un documento de la colección "Perfiles" de Firestore:
//     Perfiles/{uid}   ->  { name, edad, altura, urlAvatar? }
// El id del documento es el uid del usuario en Firebase Auth: así cada
// cuenta tiene exactamente un perfil.
// Además, el perfil "es dueño" de la subcolección de mensajes:
//     Perfiles/{uid}/Mensajes/{idMensaje}
// que escucha en TIEMPO REAL (descargarMensajes) y, cuando cambia, avisa a
// la pantalla interesada mediante un CALLBACK (onMessageReceived).
// Se guarda en Dataholder.instance.perfilUsuario.
// =====================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'Mensaje.dart';

/// Perfil del usuario logueado. Clase modelo (no es un widget).
class Perfil {
  /// Acceso a Cloud Firestore.
  var db=FirebaseFirestore.instance;

  /// Id del documento = uid del usuario en Firebase Auth.
  String uid="";
  /// Nombre del usuario.
  String? name;
  /// Edad en años.
  int? edad;
  /// Altura (double: admite decimales).
  double? altura=0.0;
  /// Mensajes de "Perfiles/{uid}/Mensajes". Los rellena descargarMensajes().
  List<Mensaje> mensajes=<Mensaje>[];
  /// Imagen mostrada en la vista: en memoria al elegirla o desde la URL
  /// guardada en Firestore al volver a cargar el perfil.
  Image? avatar;

  /// URL de descarga del avatar en Firebase Storage, persistida en Firestore.
  String? urlAvatar;
  /// CALLBACK: una función guardada en una variable. El perfil la llama cuando
  /// cambian los mensajes, pasando el número total. Así el modelo avisa a la
  /// pantalla (MessagesView) sin necesidad de conocerla. Es nullable (`?`)
  /// porque al principio nadie se ha suscrito.
  Function(int numeroMensajes)? onMessageReceived;

  /// Constructor con parámetros con nombre (y opcionales): Perfil(uid: ..., name: ...).
  Perfil({required this.uid,this.name, this.edad, this.altura, this.urlAvatar}){
    if (urlAvatar != null && urlAvatar!.isNotEmpty) {
      avatar=Image.network(urlAvatar!);
    }
  }

  /// Registra la función que se llamará cuando cambien los mensajes
  /// (MessagesView le pasa su método mensajeRecibido en initState).
  void setOnMessageReceived(Function(int numeroMensajes)? onMessageReceived){
    this.onMessageReceived=onMessageReceived;
  }

  /// Constructor "factory" para LEER de Firestore. Se usa con withConverter
  /// (ver OnBoardingView): Firestore nos da el DocumentSnapshot y esta función
  /// lo convierte en un objeto Perfil.
  ///
  /// `data?['name']`: el `?` evita el error si data es null (devuelve null).
  /// `as num?` + toInt()/toDouble(): Firestore puede devolver los números como
  /// int o como double, así que los leemos como num y luego convertimos.
  factory Perfil.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Perfil(
      uid:snapshot.id,
      name: data?['name'] as String?,
      edad: (data?['edad'] as num?)?.toInt(),
      altura: (data?['altura'] as num?)?.toDouble(),
      urlAvatar:data?['urlAvatar'] as String?,
    );
  }

  /// Conversión contraria: Perfil -> Map, para guardarlo con set().
  /// Solo incluye los campos que no son null.
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (edad != null) "edad": edad,
      if (altura != null) "altura": altura,
      if (urlAvatar != null) "urlAvatar": urlAvatar,
    };
  }
  
  /// Empieza a escuchar EN TIEMPO REAL los mensajes del usuario (máximo 20)
  /// en "Perfiles/{uid}/Mensajes".
  ///
  /// Cada vez que se añade, cambia o borra un mensaje en Firestore, el Stream
  /// emite un evento con TODOS los documentos de la consulta: vaciamos la
  /// lista, la volvemos a llenar y avisamos con el callback onMessageReceived.
  Future<void> descargarMensajes() async{
    FirebaseFirestore db=FirebaseFirestore.instance;

    // Fecha de ejemplo para el filtro comentado de abajo (ahora no se usa).
    Timestamp timestamp=Timestamp.fromDate(DateTime.utc(2026, 01, 01));

    // `uid!`: el `!` le dice a Dart "confía, no es null"; si lo fuera, la app falla.
    // Ruta de la SUBCOLECCIÓN: "Perfiles/" + uid + "/Mensajes".
    // .limit(20): como máximo 20 documentos. Los .where comentados son
    // ejemplos de filtros que se pueden activar.
    final docRef=db.collection("Perfiles/"+uid!+"/Mensajes")
        //.where("leido",isEqualTo: false)
        //.where("enviado",isGreaterThan: timestamp)
        .limit(20);
        /*.withConverter(
        fromFirestore: Mensaje.fromFirestore,
        toFirestore: (Mensaje mensaje, _) => mensaje.toFirestore());*/



    // snapshots() = Stream con los resultados de la consulta en tiempo real.
    // listen(alRecibir, onError: ...): la primera función se ejecuta con cada cambio.
    docRef.snapshots().listen(
          (event) {
            mensajes.clear();
            for (var docSnapshot in event.docs) {
              Map<String,dynamic> fila=docSnapshot.data();
              mensajes.add(Mensaje(docSnapshot.id,fila));
            }
            // La pantalla de mensajes puede no estar abierta todavía.
            onMessageReceived?.call(mensajes.length);
          } ,
      // NOTA: si falla la escucha (por ejemplo, por permisos) solo se imprime.
      onError: (error) => print("Listen failed: $error"),
    );

    // Alternativa SIN tiempo real: leer una sola vez con get() (comentada).
    /*
    final querySnapshot=await docRef.get();

    for (var docSnapshot in querySnapshot.docs) {
      Map<String,dynamic> fila=docSnapshot.data();

      mensajes.add(Mensaje(docSnapshot.id,fila));
    }*/
    // NOTA: este print casi siempre muestra 0. listen() NO espera a que lleguen
    // los datos: registra la función y sigue, así que llegamos aquí antes del
    // primer evento. Por eso el `await` de OnBoardingView no espera los mensajes.
    print("HAY EN TOTAL: "+mensajes.length.toString());


  }

  /// Añade un mensaje nuevo a la lista local y como documento nuevo en
  /// "Perfiles/{uid}/Mensajes". `add()` hace que Firestore genere el id.
  /// Como hay un listener activo, Firestore también notificará el cambio y la
  /// lista se recargará sola.
  void agregarNuevoMensaje(Mensaje m) async{
    this.mensajes.add(m);
    // Ojo: esta variable local `mensajes` (una CollectionReference) "tapa" a la
    // lista del objeto dentro de este método; por eso arriba se usa `this.mensajes`.
    final mensajes = db.collection("Perfiles/" +this.uid!+ "/Mensajes");
    await mensajes.add(m.toFirestore());
  }

  /// Marca como leídos los mensajes que no lo estaban y guarda cada cambio en
  /// Firestore (Mensaje.update). Se llama al entrar en MessagesView.
  /// Con `await` dentro del bucle, se espera a guardar uno antes del siguiente.
  void marcarMensajesLeidos() async{
    for(Mensaje m in mensajes){
      if(!m.leido){
        m.leido=true;
        await m.update(uid!);
      }
    }

  }


}
