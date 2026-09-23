import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../FbObjects/Perfil.dart';

class Profileview extends StatelessWidget{
  TextEditingController edadController=TextEditingController();
  TextEditingController alturaController=TextEditingController();
  FirebaseFirestore db=FirebaseFirestore.instance;
  late BuildContext miContext;

  void funConfirmar(){
    if(edadController.text.isNotEmpty &&
        alturaController.text.isNotEmpty) {
      final perfiles = db.collection("Perfiles");
      final perfil = new Perfil(
        uid:FirebaseAuth.instance.currentUser!.uid,
        name: "Yony",
        edad: int.parse(edadController.text),
        altura: double.parse(alturaController.text)
      );
      perfiles.doc(FirebaseAuth.instance.currentUser!.uid).set(perfil.toFirestore());
      Navigator.popAndPushNamed(miContext, "/HomeView");
    }
  }

  void funSalir(){
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    miContext=context;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextField(controller: edadController,decoration: InputDecoration(hintText: "Edad"),),
            TextField(controller: alturaController,decoration: InputDecoration(hintText: "Altura"),),
            Row(
              mainAxisAlignment: .center,
              children: [
                TextButton(onPressed: funConfirmar, child: Text("Confirmar")),
                TextButton(onPressed: funSalir, child: Text("Salir")),
              ],
            )
          ],

        ),

      ),

    );
  }

}