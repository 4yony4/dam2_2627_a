import 'package:flutter/material.dart';

class Loginview extends StatelessWidget{

  void funClickLogin(){
    print("---->>>>>>>> LOGIN PRESIONADO");

  }

  void funClickRegistro(){
    print("---->>>>>>>> REGISTRO PRESIONADO");
  }

  @override
  Widget build(BuildContext context) {
    TextStyle tsEstiloTexto=new TextStyle(fontSize: 30,backgroundColor:Colors.red);

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title:new Text("MI APP 1"),),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          Text("LOGIN",style: tsEstiloTexto,),
          TextField(decoration: InputDecoration(hintText: "Usuario"),),
          TextField(decoration: InputDecoration(hintText: "Contraseña"),),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: funClickLogin, child: Text("Login")),
              TextButton(onPressed: funClickRegistro, child: Text("Registrarse"))
            ],
          )
        ],
      ),
    );
  }
}