import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profileview extends StatelessWidget{
  TextEditingController edadController=TextEditingController();
  TextEditingController alturaController=TextEditingController();
  FirebaseFirestore db=FirebaseFirestore.instance;
  late BuildContext miContext;

  void funConfirmar(){
    if(edadController.text.isNotEmpty &&
        alturaController.text.isNotEmpty) {
      final perfiles = db.collection("Perfiles");
      final perfil = <String, dynamic>{
        "name": "Yony",
        "edad": edadController.text,
        "altura": alturaController.text,
        "profe": true,
        "asignaturas": ["PMDM", "PSP", "AD", "MMEQ"]
      };
      perfiles.doc(FirebaseAuth.instance.currentUser!.uid).set(perfil);
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