import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_core;
import 'package:dam2_2627_a/DataHolder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class Storageadmin {

  final storage = FirebaseStorage.instance;

  Storageadmin(){
    //storage.useStorageEmulator("127.0.0.1", 9199);


  }

  Future<String> subirAvatar(XFile f) async {
    String rutaURL="";

    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to 'images/mountains.jpg'
    String ruta="usuarios/"+Dataholder.instance.perfilUsuario.uid!+"/imagenes/avatar.jpg";
    final rutaImagen = storageRef.child(ruta);

    final result = await FlutterImageCompress.compressWithFile(
      f.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
      rotate: 90,
    );

    try {
      await rutaImagen.putData(result!);
      rutaURL=await rutaImagen.getDownloadURL();
      print("RUTA DESCARGA: "+rutaURL);

    } on firebase_core.FirebaseException catch (e) {
      print(e);
      // ...
    }

    /*File file=File(f.path);
    try {
      await rutaImagen.putFile(file);
      rutaURL=await rutaImagen.getDownloadURL();
      print("RUTA DESCARGA: "+rutaURL);

    } on firebase_core.FirebaseException catch (e) {
      print(e);
      // ...
    }*/
    return rutaURL;

  }



}