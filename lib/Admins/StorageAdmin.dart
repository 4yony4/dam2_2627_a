import 'package:firebase_storage/firebase_storage.dart';

class Storageadmin {

  final storage = FirebaseStorage.instance;

  Storageadmin(){
    storage.useStorageEmulator("10.0.2.2", 9199);
  }



}