import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
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
      body: SafeArea(
        // Center + SingleChildScrollView: el formulario queda centrado y,
        // si se abre el teclado, se puede hacer scroll en vez de desbordar.
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppEspacios.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppEspacios.anchoFormulario),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(AppEspacios.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.badge_outlined, size: AppEspacios.iconoGrande, color: AppColores.principal),
                      SizedBox(height: AppEspacios.lg),
                      TextField(controller: edadController,decoration: InputDecoration(hintText: "Edad",prefixIcon: Icon(Icons.cake_outlined)),),
                      SizedBox(height: AppEspacios.md),
                      TextField(controller: alturaController,decoration: InputDecoration(hintText: "Altura",prefixIcon: Icon(Icons.height_rounded)),),
                      SizedBox(height: AppEspacios.lg),
                      Row(
                        children: [
                          Expanded(child: OutlinedButton(onPressed: funSalir, child: Text("Salir"))),
                          SizedBox(width: AppEspacios.md),
                          Expanded(child: FilledButton(onPressed: funConfirmar, child: Text("Confirmar"))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}