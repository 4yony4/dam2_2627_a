// =====================================================================
// DataHolder.dart — ESTADO COMPARTIDO ENTRE PANTALLAS (SINGLETON)
// ---------------------------------------------------------------------
// Cada pantalla es un objeto distinto y no "ve" los datos de las demás.
// Dataholder es un almacén con UNA ÚNICA instancia para toda la app
// (patrón Singleton): cualquier vista accede con Dataholder.instance.
//
// Qué guarda:
//  - perfilUsuario: el Perfil del usuario logueado (lo carga OnBoardingView).
//  - mensajeSeleccionado: el mensaje pulsado en MessagesView, que luego
//    muestra MessageDetailView.
//  - Datos de la barra inferior (badges e índice seleccionado), que usan
//    HomeView, MessagesView e Insbotbarstyle1.
// Firestore: escucha en tiempo real el documento "Perfiles/{uid}".
// =====================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';
import 'package:flutter/cupertino.dart';

import 'Admins/DeviceAdmin.dart';
import 'Admins/StorageAdmin.dart';
import 'FbObjects/Mensaje.dart';
import 'FbObjects/Perfil.dart';

/// Almacén global de datos de la app (patrón Singleton).
///
/// Es una clase normal de Dart (no es un widget): no dibuja nada, solo
/// guarda datos que necesitan varias pantallas.
class Dataholder {

  Storageadmin storageadmin=Storageadmin();
  Deviceadmin? deviceadmin;

  /// Acceso a Cloud Firestore (FirebaseFirestore.instance también es un singleton).
  var db = FirebaseFirestore.instance;
  /// Constructor PRIVADO: el `_` lo hace privado a este archivo, así nadie
  /// puede escribir `Dataholder()` desde fuera y crear una segunda copia.
  Dataholder._();

  /// La única instancia que existe. `static`: pertenece a la clase, no a un
  /// objeto; `final`: no se puede reasignar. Uso: Dataholder.instance.
  static final Dataholder instance = Dataholder._();

  /// Perfil del usuario con sesión iniciada (lo asigna OnBoardingView).
  ///
  /// `late` = "prometo darle valor antes de usarla": Dart no exige
  /// inicializarla aquí, pero si se lee antes de asignarla la app lanza un
  /// LateInitializationError.
  late Perfil perfilUsuario;
  /// Mensaje pulsado en MessagesView para mostrarlo en MessageDetailView.
  /// El `?` indica que puede ser null (al principio no hay ninguno elegido).
  Mensaje? mensajeSeleccionado;

  //Variables compartidas del boton bar
  // Están aquí (y no dentro de la barra) porque cada pantalla crea su propia
  // barra inferior: así todas muestran los mismos badges y la pestaña correcta.
  /// true = se muestra el puntito en la pestaña "Notifications".
  bool blNotificacionesBadge=true;
  /// Texto del badge de "Messages" (nº de no leídos). "" = no se muestra.
  String sMessagesBadgeText="";
  /// Pestaña seleccionada en la barra (0 Principal, 1 Notifications, 2 Messages).
  int iBotBarIndex=0;

  /// Empieza a ESCUCHAR en tiempo real el documento "Perfiles/{uid}".
  ///
  /// snapshots() devuelve un Stream: un "grifo" que emite un evento al
  /// principio y otro cada vez que el documento cambia en Firestore.
  /// listen() indica qué hacer con cada evento. Lo llama OnBoardingView
  /// después de cargar el perfil.
  void initFirebaseListeners(){
    final docRef = db.collection("Perfiles").doc(perfilUsuario.uid);
    // NOTA: de momento solo se imprime por consola (y los errores, también solo
    // se imprimen). Se podría usar para mantener perfilUsuario al día en vivo.
    docRef.snapshots().listen(
          (event) => print("---->>>>current data: ${event.data()}"),
      onError: (error) => print("Listen failed: $error"),
    );
  }

  void initDeviceadmin(BuildContext context){
    deviceadmin = Deviceadmin(context);
  }


}
