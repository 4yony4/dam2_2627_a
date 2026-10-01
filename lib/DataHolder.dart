import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';

import 'FbObjects/Mensaje.dart';
import 'FbObjects/Perfil.dart';

class Dataholder {

  var db = FirebaseFirestore.instance;
  Dataholder._();

  static final Dataholder instance = Dataholder._();

  late Perfil perfilUsuario;
  Mensaje? mensajeSeleccionado;

  //Variables compartidas del boton bar
  bool blNotificacionesBadge=true;
  String sMessagesBadgeText="";
  int iBotBarIndex=0;

  void initFirebaseListeners(){
    final docRef = db.collection("Perfiles").doc(perfilUsuario.uid);
    docRef.snapshots().listen(
          (event) => print("---->>>>current data: ${event.data()}"),
      onError: (error) => print("Listen failed: $error"),
    );
  }


}
