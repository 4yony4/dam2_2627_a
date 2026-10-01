import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/FbObjects/Perfil.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';
import '../FbObjects/Mensaje.dart';

class Onboardingview extends StatefulWidget {
  const Onboardingview({ super.key });

  @override
  State<Onboardingview> createState() => _Onboardingview();
}

class _Onboardingview extends State<Onboardingview> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int _iProgress=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarRecursos();

  }

  /**
   *
   */
  void cargarRecursos() async{
    await recursos1();
    setState(() {
      _iProgress=20;
    });
    await recursos2();
    setState(() {
      _iProgress=80;
    });
    await recursos3();
    setState(() {
      _iProgress=100;
    });



    if(FirebaseAuth.instance.currentUser==null){
      Navigator.popAndPushNamed(context, "/LoginView");
    }
    else{//SIEMPRE Y CUANDO SE HAYA LOGEADO O REGISTRO ANTES
      String uid=FirebaseAuth.instance.currentUser!.uid;
      print("EL UID DEL URUSARIO LOGEADO ES: "+uid);

      final docRef = db.collection("Perfiles").doc(uid).withConverter(
        fromFirestore: Perfil.fromFirestore,
        toFirestore: (Perfil perfil, _) => perfil.toFirestore(),
      );

      final docSnap = await docRef.get();
      //Perfil? perfil=docSnap.data();
      Dataholder.instance.perfilUsuario=docSnap.data()!;

      Dataholder.instance.initFirebaseListeners();

      if(Dataholder.instance.perfilUsuario==null){//NO TIENE PERFIL EN LA BASE DE DATOS
        Navigator.popAndPushNamed(context, "/Profileview");
      }
      else{
        //SI TIENE PERFIL EN LA BASE DATOS
        //print("EL UID DEL URUSARIO LOGEADO ES: "+Dataholder.instance.perfilUsuario.altura.toString());
        await Dataholder.instance.perfilUsuario.descargarMensajes();

        int numNoLeido=0;
        for(Mensaje m in Dataholder.instance.perfilUsuario.mensajes){
          if(!m.leido)numNoLeido++;
        }

        Dataholder.instance.sMessagesBadgeText=numNoLeido.toString();

        Navigator.popAndPushNamed(context, "/HomeView");
      }
    }
  }

  Future<void> recursos1() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> recursos2() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> recursos3() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppEspacios.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppEspacios.anchoFormulario),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadios.tarjeta),
                    child: Image.network(
                      'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                      // Si no hay conexión mostramos un icono en vez del error rojo.
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.flutter_dash, size: AppEspacios.iconoGrande*2, color: AppColores.principal),
                    ),
                  ),
                  /*Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: CircularProgressIndicator(),
                  ),*/
                  Padding(padding: EdgeInsets.fromLTRB(0, AppEspacios.xl+AppEspacios.md, 0, AppEspacios.md),
                    // TweenAnimationBuilder: la barra avanza suavemente en vez de "saltar".
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _iProgress/100),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      builder: (context, valor, child) {
                        return LinearProgressIndicator(
                          value: valor,
                          minHeight: AppEspacios.sm,
                          borderRadius: BorderRadius.circular(AppEspacios.sm),
                        );
                      },
                    )
                  ),
                  Text("$_iProgress%", style: AppTextos.tituloLista.copyWith(color: AppColores.oscuro))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}