import 'package:cloud_firestore/cloud_firestore.dart';

class Mensaje {
  String? uid;
  String? titulo;
  String? cuerpo;
  bool? leido;
  Timestamp? enviado;

  /*Mensaje({this.uid,this.titulo, this.cuerpo, this.leido,this.enviado}){
    //enviado=Timestamp.fromDate(DateTime.now());
  }*/

  Mensaje(Map<String,dynamic> fila){

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


}