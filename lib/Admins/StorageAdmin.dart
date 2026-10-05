import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Storageadmin {

  final storage = FirebaseStorage.instance;

  Storageadmin(){
    //storage.useStorageEmulator("127.0.0.1", 9199);


  }

  Future<void> subirImagen(XFile f) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to 'images/mountains.jpg'
    final rutaImagen = storageRef.child("images/mountains.jpg");

    File file=File(f.path);

    try {
      await rutaImagen.putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      // ...
    }
    return;

  }



}