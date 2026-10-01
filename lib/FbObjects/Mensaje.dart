// =====================================================================
// Mensaje.dart — MODELO DE UN MENSAJE
// ---------------------------------------------------------------------
// Representa un documento de la SUBCOLECCIÓN de Firestore:
//     Perfiles/{uidPerfil}/Mensajes/{uidMensaje}
// con los campos titulo (String), cuerpo (String), leido (bool) y
// enviado (Timestamp).
// Sabe convertirse en Map para guardarse (toFirestore) y actualizarse a sí
// mismo en Firestore (update). Lo crean Perfil.descargarMensajes() (al leer
// de Firestore) y MessagesView (al pulsar el botón "+").
// =====================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/views/MessagesView.dart';

/// Un mensaje del usuario. Es una clase de datos (modelo), no un widget.
class Mensaje {
  /// Acceso a Firestore para poder guardarse a sí mismo (ver update()).
  var db=FirebaseFirestore.instance;

  /// Id del documento en Firestore. No es un campo DENTRO del documento,
  /// es su "nombre". `String?`: puede ser null.
  String? uid;
  /// Título del mensaje.
  String? titulo;
  /// Texto completo del mensaje.
  String? cuerpo;
  /// Si el usuario ya lo ha visto. No es nullable porque empieza en false.
  bool leido=false;
  /// Fecha y hora de envío. Timestamp es el tipo de fecha de Firestore
  /// (se pasa a DateTime con .toDate()).
  Timestamp? enviado;

  // Constructor antiguo con parámetros con nombre (comentado, no se usa).
  /*Mensaje({this.uid,this.titulo, this.cuerpo, this.leido,this.enviado}){
    //enviado=Timestamp.fromDate(DateTime.now());
  }*/

  /// Constructor con nombre: crea un mensaje pasando todos los campos en orden.
  /// Lo usa MessagesView para crear un mensaje nuevo antes de subirlo.
  /// `this.uid` asigna el parámetro directamente al campo (atajo de Dart).
  Mensaje.initCampos(this.uid,this.titulo, this.cuerpo, this.leido,this.enviado);

  /// Constructor principal: crea un Mensaje a partir del id del documento y
  /// de la "fila" leída de Firestore (un Map campo -> valor).
  /// `as String` convierte el valor `dynamic` del Map al tipo concreto.
  Mensaje(this.uid,Map<String,dynamic> fila){

      // NOTA: si a un documento le falta algún campo (o tiene otro tipo), el `as`
      // lanza una excepción. ¿Cómo lo harías más seguro? (pista: `as String?`)
      this.titulo=fila["titulo"] as String;
    this.cuerpo=fila["cuerpo"] as String;
    this.leido=fila["leido"] as bool;
    this.enviado=fila["enviado"] as Timestamp;

  }


  // Versión con fromFirestore para usar con withConverter (como hace Perfil).
  // Está comentada: en su lugar se usa el constructor Mensaje(uid, fila).
  /*
  factory Mensaje.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Mensaje(
      uid:snapshot.id,
      titulo: data?['titulo'] as String?,
      cuerpo: data?['cuerpo'] as String?,
      leido: data?['leido'] as bool?,
      enviado:data?['enviado'] as Timestamp?,
    );
  }
*/
  /// Convierte el mensaje en un Map para guardarlo en Firestore.
  /// Los `if` dentro del mapa ("collection if") solo añaden la clave si el
  /// valor no es null.
  Map<String, dynamic> toFirestore() {
    return {
      if (titulo != null) "titulo": titulo,
      if (cuerpo != null) "cuerpo": cuerpo,
      if (leido != null) "leido": leido,
      if (enviado != null) "enviado": enviado,
    };
  }

  /// Guarda (sobrescribe) este mensaje en "Perfiles/{sPerfilUID}/Mensajes/{uid}".
  ///
  /// `set()` reemplaza el documento entero. Devuelve un Future, así quien lo
  /// llame puede esperar con `await` (lo hace Perfil.marcarMensajesLeidos).
  Future<void> update(String sPerfilUID)async{
    // La ruta se forma concatenando colección / documento / subcolección.
    return await db.collection("Perfiles/"+sPerfilUID+"/Mensajes").doc(uid).set(toFirestore());
  }


}