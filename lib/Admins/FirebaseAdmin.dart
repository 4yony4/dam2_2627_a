import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  Future<List<Marker>> descargarPOIs() async {
    List<Marker> marcadores=<Marker>[];
    final docRef=db.collection("POIs").limit(20);
    QuerySnapshot<Map<String, dynamic>> query=await docRef.get();
    for (var docSnapshot in query.docs) {
      Map<String,dynamic> fila=docSnapshot.data();
      GeoPoint geoPoint = fila["geoloc"];
      Marker marker=Marker(
          point: LatLng(geoPoint.latitude, geoPoint.longitude),
          child: Icon(Icons.pin_drop)
      );
      marcadores.add(marker);
    }
    return marcadores;
  }

  void onMarkersChanged(){
    List<Marker> marcadores=<Marker>[];
    final docRef=db.collection("POIs").limit(20);
    docRef.snapshots().listen(
          (event) {
        marcadores.clear();

        for (var docSnapshot in event.docs) {
          Map<String,dynamic> fila=docSnapshot.data();
          GeoPoint geoPoint = fila["geoloc"];
          Marker marker=Marker(
              point: LatLng(geoPoint.latitude, geoPoint.longitude),
              child: Icon(Icons.pin_drop)
          );
          marcadores.add(marker);
        }
        print("1111");
      } ,
      // NOTA: si falla la escucha (por ejemplo, por permisos) solo se imprime.
      onError: (error) => print("Listen failed: $error"),
    );
  }

}