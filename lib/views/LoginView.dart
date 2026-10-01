// =====================================================================
// LoginView.dart — INICIO DE SESIÓN (ruta "/LoginView")
// ---------------------------------------------------------------------
// Formulario de email + contraseña contra FIREBASE AUTHENTICATION.
// Si el login va bien, mira en Firestore si existe "Perfiles/{uid}":
//   - No existe -> "/Profileview" (el usuario debe crear su perfil)
//   - Existe    -> "/HomeView"
// El botón "Registrarse" lleva a "/RegisterView".
// Navega con popAndPushNamed (con "atrás" no se vuelve al login).
// No escribe en Dataholder (ver NOTA en funClickLogin).
// =====================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// NOTA: un StatelessWidget debería tener solo campos `final` (el analizador
// avisa con must_be_immutable). Funciona, pero lo correcto sería un
// StatefulWidget con los controllers en su State.
/// Pantalla de login. Es un StatelessWidget: no usa setState; el texto que
/// escribe el usuario lo guardan los TextEditingController.
class Loginview extends StatelessWidget{
  /// Instancia de Firebase Authentication (otro singleton, como Dataholder).
  var faInstance=FirebaseAuth.instance;
  /// BuildContext guardado en build() para poder navegar desde los métodos de
  /// los botones. `late`: se asigna en build(), antes de cualquier pulsación.
  late BuildContext miContext;
  /// Controlador del campo "Usuario" (email): con .text leemos lo escrito.
  TextEditingController userController = new TextEditingController();
  /// Controlador del campo "Contraseña".
  TextEditingController passwordController = new TextEditingController();
  /// Acceso a Firestore para comprobar si el usuario ya tiene perfil.
  FirebaseFirestore db=FirebaseFirestore.instance;

  /// Se ejecuta al pulsar "Login".
  ///
  /// Es `async` porque signInWithEmailAndPassword va a Internet y tarda: con
  /// `await` esperamos la respuesta sin congelar la pantalla.
  void funClickLogin() async{
    String usuario=userController.text;
    String pass=passwordController.text;
    // NOTA: imprime la contraseña por consola: nunca hacerlo en una app real.
    print("---->>>>>>>> LOGIN PRESIONADO "+usuario+"   "+pass);

    // try / on FirebaseAuthException catch: si el login falla (contraseña mala,
    // usuario inexistente...), Firebase LANZA una excepción. La capturamos aquí
    // para que la app no se cierre; e.code indica el motivo.
    try {
      await faInstance.signInWithEmailAndPassword(
          email: usuario,
          password: pass
      );
      print("LOGIN BIEN!!!");

      // Leemos el documento "Perfiles/{uid}" para saber si ya creó su perfil.
      // .then(...) es otra forma de usar un Future (en lugar de await): la
      // función se ejecuta cuando llega el resultado.
      final docRef = db.collection("Perfiles").doc(FirebaseAuth.instance.currentUser!.uid);
      docRef.get().then(
            (DocumentSnapshot doc) {
          // NOTA: aquí no se guarda el perfil en Dataholder.perfilUsuario y HomeView
          // lo lee al crearse: tras este login (sin pasar por OnBoarding) puede fallar
          // con LateInitializationError o mostrar el perfil del usuario anterior.
          if(doc.data()==null){//NO TIENE PERFIL EN LA BASE DE DATOS
            Navigator.popAndPushNamed(miContext, "/Profileview");
          }
          else{
            //SI TIENE PERFIL EN LA BASE DATOS
            // `data` no se usa (el analizador avisa de variable sin uso).
            final data = doc.data() as Map<String, dynamic>;
            Navigator.popAndPushNamed(miContext, "/HomeView");
          }
        },
        onError: (e) => print(e.toString()),
      );

    } on FirebaseAuthException catch (e) {
      // NOTA: los errores solo se imprimen en consola; el usuario no ve ningún
      // aviso (se podría mostrar un SnackBar). Además, en proyectos de Firebase
      // recientes suele llegar el código 'invalid-credential' en vez de estos dos.
      print("----------------->>>>>> "+e.toString());
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }


    // Versiones anteriores del login (comentadas): usuario fijo, sin Firebase.
    /*if(usuario=="Yony" && pass=="123456"){
      Navigator.popAndPushNamed(miContext, "/HomeView");
    }*/
    //Navigator.pushNamed(miContext, "/HomeView");
    //Navigator.popAndPushNamed(miContext, "/HomeView");

  }

  /// Botón "Registrarse": sustituye el login por la pantalla de registro.
  void funClickRegistro(){
    print("---->>>>>>>> REGISTRO PRESIONADO");
    Navigator.popAndPushNamed(miContext, "/RegisterView");
  }

  /// Dibuja el formulario de login.
  @override
  Widget build(BuildContext context) {
    print("PINTADO LOGIN");
    // Guardamos el context para usarlo luego en los métodos de los botones.
    miContext=context;
    // Estilo de texto tomado de los tokens de diseño (AppTheme.dart).
    TextStyle tsEstiloTexto=AppTextos.tituloPantalla;

    // TODO: implement build
    // Scaffold: estructura básica de una pantalla Material (appBar, body...).
    return Scaffold(
      appBar: new AppBar(title:new Text("MI APP DAM2627"),),
      // SafeArea: evita el notch y la barra de estado del móvil.
      body: SafeArea(
        // Center + SingleChildScrollView: el formulario queda centrado y,
        // si se abre el teclado, se puede hacer scroll en vez de desbordar.
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppEspacios.lg),
            // ConstrainedBox: en tablets el formulario no pasa de anchoFormulario.
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppEspacios.anchoFormulario),
              // Card toma su color, forma y sombra del cardTheme de MiApp.dart.
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(AppEspacios.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // stretch: los hijos (campos y botones) ocupan todo el ancho de la tarjeta.
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.lock_outline_rounded, size: AppEspacios.iconoGrande, color: AppColores.principal),
                      SizedBox(height: AppEspacios.sm),
                      Text("LOGIN",style: tsEstiloTexto,textAlign: TextAlign.center,),
                      SizedBox(height: AppEspacios.lg),
                      // TextField + controller: el controller guarda lo que escribe el usuario.
                      TextField(controller: userController,decoration: InputDecoration(hintText: "Usuario",prefixIcon: Icon(Icons.person_outline_rounded)),),
                      SizedBox(height: AppEspacios.md),
                      // obscureText: true -> oculta la contraseña con puntos.
                      TextField(obscureText: true,controller:passwordController,decoration: InputDecoration(hintText: "Contraseña",prefixIcon: Icon(Icons.key_rounded)),),
                      SizedBox(height: AppEspacios.lg),
                      // onPressed recibe la FUNCIÓN (sin paréntesis): se ejecutará al pulsar.
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