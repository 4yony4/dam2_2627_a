// =====================================================================
// RegisterView.dart — REGISTRO DE USUARIO NUEVO (ruta "/RegisterView")
// ---------------------------------------------------------------------
// Crea una cuenta en FIREBASE AUTHENTICATION con email y contraseña.
// Tras crearla, Firebase deja al usuario con la sesión ya iniciada.
//   - Cuenta creada -> "/Profileview" (para que rellene su perfil)
//   - "Cancelar"    -> "/LoginView"
// No escribe en Firestore (el perfil se crea después, en ProfileView) ni en
// Dataholder. Navega con popAndPushNamed (sustituye la pantalla).
// =====================================================================
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// NOTA: igual que en LoginView, un StatelessWidget con campos no `final`
// (el analizador avisa con must_be_immutable).
/// Pantalla de registro. StatelessWidget: los datos del formulario los
/// guardan los TextEditingController, no hace falta setState.
class Registerview extends StatelessWidget{
  /// Instancia de Firebase Authentication.
  var faInstance=FirebaseAuth.instance;
  /// BuildContext guardado en build() para navegar desde los botones.
  late BuildContext miContext;
  /// Controlador del campo "Usuario" (email).
  TextEditingController userController = new TextEditingController();
  /// Controlador del campo "Contraseña".
  TextEditingController passwordController = new TextEditingController();
  /// Controlador del campo "Repetir Contraseña".
  TextEditingController repasswordController = new TextEditingController();


  /// Botón "Registrar": comprueba que las contraseñas coinciden y crea la
  /// cuenta. Devuelve `Future<void>` porque es `async`.
  Future<void> funClickRegistro() async {

    // Validación local antes de llamar a Firebase.
    // NOTA: el aviso solo sale por consola; el usuario no ve nada.
    if(repasswordController.text!=passwordController.text){
      print("CONTRASEÑAS NO COINCIDEN");
    }
    else{
      // try / on / catch: `on FirebaseAuthException` captura los errores propios
      // de Firebase (contraseña débil, email ya usado...) y el `catch (e)` final,
      // cualquier otro error.
      try {
        // createUserWithEmailAndPassword crea el usuario y devuelve un UserCredential.
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userController.text,
          password: passwordController.text,
        );
        if(credential.user!=null){
          Navigator.popAndPushNamed(miContext, "/Profileview");
        }

      } on FirebaseAuthException catch (e) {
        // NOTA: los errores solo se imprimen; no hay mensaje en pantalla.
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

  /// Botón "Cancelar": vuelve al login sustituyendo esta pantalla.
  void funClickCancelar(){
    Navigator.popAndPushNamed(miContext, "/LoginView");
  }

  /// Dibuja el formulario de registro (mismo diseño que LoginView).
  @override
  Widget build(BuildContext context) {
    miContext=context;
    TextStyle tsEstiloTexto=AppTextos.tituloPantalla;

    // TODO: implement build
    // Misma estructura que LoginView:
    // Scaffold > SafeArea > Center > SingleChildScrollView > Card > Column.
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
                      // Segunda contraseña para confirmar que no hay errores al teclear.
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