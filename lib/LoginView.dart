import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginview extends StatelessWidget{
  var faInstance=FirebaseAuth.instance;
  late BuildContext miContext;
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void funClickLogin() async{
    String usuario=userController.text;
    String pass=passwordController.text;
    print("---->>>>>>>> LOGIN PRESIONADO "+usuario+"   "+pass);

    try {
      await faInstance.signInWithEmailAndPassword(
          email: usuario,
          password: pass
      );
      print("LOGIN BIEN!!!");
      Navigator.popAndPushNamed(miContext, "/HomeView");

    } on FirebaseAuthException catch (e) {
      print("----------------->>>>>> "+e.toString());
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }


    /*if(usuario=="Yony" && pass=="123456"){
      Navigator.popAndPushNamed(miContext, "/HomeView");
    }*/
    //Navigator.pushNamed(miContext, "/HomeView");
    //Navigator.popAndPushNamed(miContext, "/HomeView");

  }

  void funClickRegistro(){
    print("---->>>>>>>> REGISTRO PRESIONADO");
  }

  @override
  Widget build(BuildContext context) {
    miContext=context;
    TextStyle tsEstiloTexto=new TextStyle(fontSize: 30,backgroundColor:Colors.red);

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title:new Text("MI APP DAM2627"),),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          Text("LOGIN",style: tsEstiloTexto,),
          TextField(controller: userController,decoration: InputDecoration(hintText: "Usuario"),),
          TextField(controller:passwordController,decoration: InputDecoration(hintText: "Contraseña"),),
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