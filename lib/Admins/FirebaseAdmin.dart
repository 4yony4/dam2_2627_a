import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../FbObjects/Perfil.dart';

class Firebaseadmin {

  FirebaseFirestore db=FirebaseFirestore.instance;
  FirebaseAuth fa=FirebaseAuth.instance;

  Firebaseadmin(){

  }


  Future<Perfil> descargarPerfil() async{

    Perfil? perfilTemp;

    final docRef = db.collection("Perfiles")
        .doc(fa.currentUser!.uid).withConverter(
      fromFirestore: Perfil.fromFirestore,
      toFirestore: (Perfil perfil, _) => perfil.toFirestore(),
    );

    final docSnap = await docRef.get();
    //print("HEY HEY HEY!!!!!!!!!!!!!!!!!!");

    perfilTemp=docSnap.data();

    if(perfilTemp==null){
      perfilTemp=Perfil(uid: "");
    }
    else{
      perfilTemp.descargarMensajes();
    }

    //print("!!!!!!-----EL UID DEL PERFIL ES:"+perfilTemp.edad.toString());

    return perfilTemp;

  }

}