import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginview extends StatelessWidget{
  var faInstance=FirebaseAuth.instance;
  late BuildContext miContext;
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  FirebaseFirestore db=FirebaseFirestore.instance;

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

      final docRef = db.collection("Perfiles").doc(FirebaseAuth.instance.currentUser!.uid);
      docRef.get().then(
            (DocumentSnapshot doc) {
          if(doc.data()==null){//NO TIENE PERFIL EN LA BASE DE DATOS
            Navigator.popAndPushNamed(miContext, "/Profileview");
          }
          else{
            //SI TIENE PERFIL EN LA BASE DATOS
            final data = doc.data() as Map<String, dynamic>;
            Navigator.popAndPushNamed(miContext, "/HomeView");
          }
        },
        onError: (e) => print(e.toString()),
      );

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
    Navigator.popAndPushNamed(miContext, "/RegisterView");
  }

  @override
  Widget build(BuildContext context) {
    print("PINTADO LOGIN");
    miContext=context;
    TextStyle tsEstiloTexto=AppTextos.tituloPantalla;

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title:new Text("MI APP DAM2627"),),
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
                      Icon(Icons.lock_outline_rounded, size: AppEspacios.iconoGrande, color: AppColores.principal),
                      SizedBox(height: AppEspacios.sm),
                      Text("LOGIN",style: tsEstiloTexto,textAlign: TextAlign.center,),
                      SizedBox(height: AppEspacios.lg),
                      TextField(controller: userController,decoration: InputDecoration(hintText: "Usuario",prefixIcon: Icon(Icons.person_outline_rounded)),),
                      SizedBox(height: AppEspacios.md),
                      TextField(obscureText: true,controller:passwordController,decoration: InputDecoration(hintText: "Contraseña",prefixIcon: Icon(Icons.key_rounded)),),
                      SizedBox(height: AppEspacios.lg),
                      FilledButton(onPressed: funClickLogin, child: Text("Login")),
                      SizedBox(height: AppEspacios.sm),
                      TextButton(onPressed: funClickRegistro, child: Text("Registrarse"))
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