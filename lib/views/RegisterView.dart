import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
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
                      Icon(Icons.person_add_alt_1_rounded, size: AppEspacios.iconoGrande, color: AppColores.principal),
                      SizedBox(height: AppEspacios.sm),
                      Text("REGISTRO",style: tsEstiloTexto,textAlign: TextAlign.center,),
                      SizedBox(height: AppEspacios.lg),
                      TextField(controller: userController,decoration: InputDecoration(hintText: "Usuario",prefixIcon: Icon(Icons.person_outline_rounded)),),
                      SizedBox(height: AppEspacios.md),
                      TextField(obscureText: true,controller:passwordController,decoration: InputDecoration(hintText: "Contraseña",prefixIcon: Icon(Icons.key_rounded)),),
                      SizedBox(height: AppEspacios.md),
                      TextField(obscureText: true,controller:repasswordController,decoration: InputDecoration(hintText: "Repetir Contraseña",prefixIcon: Icon(Icons.key_rounded)),),
                      SizedBox(height: AppEspacios.lg),
                      FilledButton(onPressed: funClickRegistro, child: Text("Registrar")),
                      SizedBox(height: AppEspacios.sm),
                      TextButton(onPressed: funClickCancelar, child: Text("Cancelar"))
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