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
//  - Un "Admin" por servicio (firebaseadmin, storageadmin, gpsadmin,
//    apisadmin, stripeadmin, fcmadmin, nfcadmin, deviceadmin).
// Guía: docs/01-arquitectura.md
// =====================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/Admins/FirebaseAdmin.dart';
import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

import 'Admins/ApisAdmin.dart';
import 'Admins/DeviceAdmin.dart';
import 'Admins/FCMAdmin.dart';
import 'Admins/GPSAdmin.dart';
import 'Admins/NFCAdmin.dart';
import 'Admins/StorageAdmin.dart';
import 'Admins/StripeAdmin.dart';
import 'FbObjects/Mensaje.dart';
import 'FbObjects/Perfil.dart';

/// Almacén global de datos de la app (patrón Singleton).
///
/// Es una clase normal de Dart (no es un widget): no dibuja nada, solo
/// guarda datos que necesitan varias pantallas.
class Dataholder {

  Storageadmin storageadmin=Storageadmin();
  late Deviceadmin deviceadmin;
  Firebaseadmin firebaseadmin=Firebaseadmin();
  Gpsadmin gpsadmin=Gpsadmin();
  Apisadmin apisadmin=Apisadmin();
  Stripeadmin stripeadmin =Stripeadmin();
  Fcmadmin fcmadmin=Fcmadmin();
  Nfcadmin nfcadmin=Nfcadmin();

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
  /// Pestaña seleccionada en la barra (0 Principal, 1 Notifications, 2 Messages, 3 Mapa, 4 Cobro).
  int iBotBarIndex=0;

  void initDeviceadmin(BuildContext context){
    deviceadmin = Deviceadmin(context);
  }

  void initGPSUpdate(){
    gpsadmin.realTimePosition(updatePerfilGPS);
  }

  Future<Perfil> descargarPerfil() async {
    String? sTokenMovil= await fcmadmin.mostrarToken();
    perfilUsuario=await firebaseadmin.descargarPerfil(sTokenMovil);
    // Contamos los mensajes no leídos para el badge de la barra inferior.
    int numNoLeido=0;
    for(Mensaje m in perfilUsuario.mensajes){
      if(!m.leido)numNoLeido++;
    }
    // Se guarda en Dataholder para que la barra inferior de HomeView lo muestre.
    sMessagesBadgeText=numNoLeido.toString();

    return perfilUsuario;
  }

  void updatePerfilGPS(Position position){
    perfilUsuario.gpsPosition=GeoPoint(position.latitude, position.longitude);
    firebaseadmin.actualizarPerfil(perfilUsuario);
  }

  void enviarPushEnRadioDeMensaje(Mensaje m){
    fcmadmin.enviarPushEnRadio(
        lat: perfilUsuario.gpsPosition!.latitude,
        lon: perfilUsuario.gpsPosition!.longitude,
        radioKm: 10,
        titulo: m.titulo!,
        mensaje: m.cuerpo!,
      excluirEmisor: false
    );

  }


}
