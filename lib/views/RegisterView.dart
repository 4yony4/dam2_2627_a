import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registerview extends StatelessWidget{
  var faInstance=FirebaseAuth.instance;
  late BuildContext miContext;
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repasswordController = new TextEditingController();


  Future<void> funClickRegistro() async {

    if(repasswordController.text!=passwordController.text){
      print("CONTRASEÑAS NO COINCIDEN");
    }
    else{
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userController.text,
          password: passwordController.text,
        );
        if(credential.user!=null){
          Navigator.popAndPushNamed(miContext, "/Profileview");
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void funClickCancelar(){
    Navigator.popAndPushNamed(miContext, "/LoginView");
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
          Text("REGISTRO",style: tsEstiloTexto,),
          TextField(controller: userController,decoration: InputDecoration(hintText: "Usuario"),),
          TextField(obscureText: true,controller:passwordController,decoration: InputDecoration(hintText: "Contraseña"),),
          TextField(obscureText: true,controller:repasswordController,decoration: InputDecoration(hintText: "Repetir Contraseña"),),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: funClickRegistro, child: Text("Registrar")),
              TextButton(onPressed: funClickCancelar, child: Text("Cancelar"))
            ],
          )
        ],
      ),
    );




  }




}