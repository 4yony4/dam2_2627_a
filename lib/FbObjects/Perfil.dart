import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'Mensaje.dart';

class Perfil {
  String? uid;
  String? name;
  int? edad;
  double? altura=0.0;
  List<Mensaje> mensajes=<Mensaje>[];

  Perfil({this.uid,this.name, this.edad, this.altura});

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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (edad != null) "edad": edad,
      if (altura != null) "altura": altura,
    };
  }
  
  Future<void> descargarMensajes() async{
    FirebaseFirestore db=FirebaseFirestore.instance;

    Timestamp timestamp=Timestamp.fromDate(DateTime.utc(2024, 01, 01));

    final docRef=db.collection("Perfiles/"+uid!+"/Mensajes")
        //.where("leido",isEqualTo: false).limit(20)
        .where("enviado",isGreaterThan: timestamp);
        /*.withConverter(
        fromFirestore: Mensaje.fromFirestore,
        toFirestore: (Mensaje mensaje, _) => mensaje.toFirestore());*/

    final querySnapshot=await docRef.get();

    for (var docSnapshot in querySnapshot.docs) {
      Map<String,dynamic> fila=docSnapshot.data();
      mensajes.add(Mensaje(fila));
    }
    print("HAY EN TOTAL: "+mensajes.length.toString());

  }


}
