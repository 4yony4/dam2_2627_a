import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/views/MessagesView.dart';

class Mensaje {
  var db=FirebaseFirestore.instance;

  String? uid;
  String? titulo;
  String? cuerpo;
  bool leido=false;
  Timestamp? enviado;

  /*Mensaje({this.uid,this.titulo, this.cuerpo, this.leido,this.enviado}){
    //enviado=Timestamp.fromDate(DateTime.now());
  }*/

  Mensaje.initCampos(this.uid,this.titulo, this.cuerpo, this.leido,this.enviado);

  Mensaje(this.uid,Map<String,dynamic> fila){

      this.titulo=fila["titulo"] as String;
    this.cuerpo=fila["cuerpo"] as String;
    this.leido=fila["leido"] as bool;
    this.enviado=fila["enviado"] as Timestamp;

  }


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
  Map<String, dynamic> toFirestore() {
    return {
      if (titulo != null) "titulo": titulo,
      if (cuerpo != null) "cuerpo": cuerpo,
      if (leido != null) "leido": leido,
      if (enviado != null) "enviado": enviado,
    };
  }

  Future<void> update(String sPerfilUID)async{
    return await db.collection("Perfiles/"+sPerfilUID+"/Mensajes").doc(uid).set(toFirestore());
  }


}