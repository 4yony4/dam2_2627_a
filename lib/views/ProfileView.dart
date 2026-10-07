// =====================================================================
// ProfileView.dart — CREAR EL PERFIL (ruta "/Profileview")
// ---------------------------------------------------------------------
// Pide edad y altura y crea el documento "Perfiles/{uid}" en Firestore,
// usando como id el uid del usuario de Firebase Auth: así cuenta y perfil
// quedan enlazados por el mismo identificador.
//   - "Confirmar" -> guarda el perfil -> "/HomeView"
//   - "Salir"     -> cierra la app
// Se llega desde RegisterView (cuenta nueva) o LoginView (cuenta sin perfil).
// No escribe en Dataholder (ver NOTA en funConfirmar).
// =====================================================================
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../FbObjects/Perfil.dart';

// NOTA: StatelessWidget con campos no `final` (aviso must_be_immutable).
/// Pantalla para crear el perfil. StatelessWidget: los datos del formulario
/// los guardan los TextEditingController.
class Profileview extends StatelessWidget{
  /// Controlador del campo "Edad".
  TextEditingController edadController=TextEditingController();
  /// Controlador del campo "Altura".
  TextEditingController alturaController=TextEditingController();
  /// Acceso a Cloud Firestore.
  FirebaseFirestore db=FirebaseFirestore.instance;
  /// BuildContext guardado en build() para navegar desde los botones.
  late BuildContext miContext;

  /// Botón "Confirmar": si los dos campos tienen texto, crea un Perfil y lo
  /// guarda en Firestore con set() en "Perfiles/{uid}".
  Future<void> funConfirmar() async{
    if(edadController.text.isNotEmpty &&
        alturaController.text.isNotEmpty) {
      // Referencia a la colección "Perfiles".
      final perfiles = db.collection("Perfiles");
      // NOTA: el nombre está fijo a "Yony" para todos los usuarios (no hay campo
      // de nombre en esta pantalla; se puede cambiar luego en HomeView).
      // NOTA: int.parse / double.parse lanzan FormatException si el texto no es
      // un número ("abc", o "1,80" con coma). int.tryParse devolvería null.
      final perfil = new Perfil(
        uid:FirebaseAuth.instance.currentUser!.uid,
        name: "Yony",
        edad: int.parse(edadController.text),
        altura: double.parse(alturaController.text)
      );
      // Esperamos la escritura antes de abrir HomeProfileGate, que volverá a
      // leer el perfil desde Firestore.
      await perfiles.doc(FirebaseAuth.instance.currentUser!.uid).set(perfil.toFirestore());
      if (miContext.mounted) Navigator.popAndPushNamed(miContext, "/HomeView");
    }
  }

  /// Botón "Salir": exit(0) (de dart:io) cierra la app de golpe.
  /// NOTA: no es la forma recomendada de cerrar una app y en Web no funciona.
  void funSalir(){
    exit(0);
  }

  /// Dibuja el formulario del perfil.
  @override
  Widget build(BuildContext context) {
    miContext=context;
    return Scaffold(
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
                      Icon(Icons.badge_outlined, size: AppEspacios.iconoGrande, color: AppColores.principal),
                      SizedBox(height: AppEspacios.lg),
                      // NOTA: no hay keyboardType numérico; el usuario puede escribir letras.
                      TextField(controller: edadController,decoration: InputDecoration(hintText: "Edad",prefixIcon: Icon(Icons.cake_outlined)),),
                      SizedBox(height: AppEspacios.md),
                      TextField(controller: alturaController,decoration: InputDecoration(hintText: "Altura",prefixIcon: Icon(Icons.height_rounded)),),
                      SizedBox(height: AppEspacios.lg),
                      // Row con dos Expanded: cada botón ocupa la mitad del ancho disponible.
                      Row(
                        children: [
                          Expanded(child: OutlinedButton(onPressed: funSalir, child: Text("Salir"))),
                          SizedBox(width: AppEspacios.md),
                          Expanded(child: FilledButton(onPressed: funConfirmar, child: Text("Confirmar"))),
                        ],
                      )
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
