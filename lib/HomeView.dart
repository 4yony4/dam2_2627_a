import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homeview extends StatelessWidget{
  late BuildContext miContext;

  void actualizarNombre(){

  }

  void funClickLogout(){
    FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(miContext, "/LoginView");
  }

  @override
  Widget build(BuildContext context) {
    miContext=context;
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Text("HOME VIEW"),
          //TextField(controller: edadController,decoration: InputDecoration(hintText: "NOMBRE"),),
          TextButton(onPressed: funClickLogout, child: Text("Logout"))
        ],
      )
    );
  }
}