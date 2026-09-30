import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'Mensaje.dart';

class Perfil {
  var db=FirebaseFirestore.instance;

  String? uid;
  String? name;
  int? edad;
  double? altura=0.0;
  List<Mensaje> mensajes=<Mensaje>[];
  Function(int numeroMensajes)? onMessageReceived;

  Perfil({this.uid,this.name, this.edad, this.altura});

  void setOnMessageReceived(Function(int numeroMensajes)? onMessageReceived){
    this.onMessageReceived=onMessageReceived;
  }

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

    Timestamp timestamp=Timestamp.fromDate(DateTime.utc(2026, 01, 01));

    final docRef=db.collection("Perfiles/"+uid!+"/Mensajes")
        //.where("leido",isEqualTo: false)
        //.where("enviado",isGreaterThan: timestamp)
        .limit(20);
        /*.withConverter(
        fromFirestore: Mensaje.fromFirestore,
        toFirestore: (Mensaje mensaje, _) => mensaje.toFirestore());*/



    docRef.snapshots().listen(
          (event) {
            mensajes.clear();
            for (var docSnapshot in event.docs) {
              Map<String,dynamic> fila=docSnapshot.data();
              mensajes.add(Mensaje(docSnapshot.id,fila));
            }
            onMessageReceived!(mensajes.length);
          } ,
      onError: (error) => print("Listen failed: $error"),
    );

    /*
    final querySnapshot=await docRef.get();

    for (var docSnapshot in querySnapshot.docs) {
      Map<String,dynamic> fila=docSnapshot.data();

      mensajes.add(Mensaje(docSnapshot.id,fila));
    }*/
    print("HAY EN TOTAL: "+mensajes.length.toString());


  }

  void agregarNuevoMensaje(Mensaje m) async{
    this.mensajes.add(m);
    final mensajes = db.collection("Perfiles/" +this.uid!+ "/Mensajes");
    await mensajes.add(m.toFirestore());
  }

  void marcarMensajesLeidos() async{
    for(Mensaje m in mensajes){
      if(!m.leido){
        m.leido=true;
        await m.update(uid!);
      }
    }

  }


}
