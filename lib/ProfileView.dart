import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profileview extends StatelessWidget{
  TextEditingController edadController=TextEditingController();
  TextEditingController alturaController=TextEditingController();

  void funConfirmar(){

  }

  void funSalir(){

  }

  @override
  Widget build(BuildContext context) {
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