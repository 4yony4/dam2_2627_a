// =====================================================================
// InsBotBarStyle1.dart — BARRA DE NAVEGACIÓN INFERIOR REUTILIZABLE
// ---------------------------------------------------------------------
// "insLib" = librería interna: piezas que se reutilizan en varias pantallas.
// Insbotbarstyle1 envuelve un NavigationBar (Material 3) con 3 pestañas:
//   0 Principal     -> "/HomeView"
//   1 Notifications -> solo oculta su badge (no navega)
//   2 Messages      -> "/Messagesview" (y vacía el badge con el número)
// Cada pantalla (HomeView, MessagesView) crea SU PROPIA barra y le pasa los
// datos guardados en Dataholder (badges e índice). Navega con
// popAndPushNamed: cambia de pantalla sin apilarla.
// =====================================================================
import 'package:flutter/material.dart';

// NOTA: los campos no son `final` y el State los modifica (widget.xxx = ...).
// Funciona, pero lo habitual es copiarlos al State; el analizador avisa con
// must_be_immutable.
/// Barra inferior. Es un StatefulWidget porque al pulsar cambian la pestaña
/// seleccionada y los badges, y hay que redibujarla.
class Insbotbarstyle1 extends StatefulWidget{
  /// Si se muestra el puntito en "Notifications".
  bool blBadge1=true;
  /// Texto del badge de "Messages" (vacío = oculto).
  String sBadge2="";
  /// Pestaña seleccionada (0, 1 o 2).
  int iBarIndex=0;

  /// `required`: al crear la barra hay que pasar los tres parámetros con nombre.
  Insbotbarstyle1({required this.blBadge1,required this.sBadge2,required this.iBarIndex});

  /// Crea el State de la barra.
  @override
  State<Insbotbarstyle1> createState() => _Insbotbarstyle1State();
}

/// State de la barra: reacciona a las pulsaciones.
class _Insbotbarstyle1State extends State<Insbotbarstyle1> {

  /// No hace nada especial: solo llama a super.initState().
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  /// Se ejecuta al pulsar una pestaña (onDestinationSelected) con su índice.
  void BotBarItemSelected(int index){
    // En Dart 3 los `case` no "caen" al siguiente: no hace falta `break`.
    switch (index){
      case 0: {
        Navigator.popAndPushNamed(context, "/HomeView");
      }
      case 1: {
        print("NOTIFICATION");
        // NOTA: este cambio solo afecta a esta barra; no se guarda en
        // Dataholder.blNotificacionesBadge, así que en otra pantalla reaparece.
        setState(() {
          widget.blBadge1=false;
        });
      }
      case 2: {
        print("MESSAGES");
        setState(() {
          widget.sBadge2="";
        });
        Navigator.popAndPushNamed(context, "/Messagesview");
      }

    }
    // Marca como seleccionada la pestaña pulsada.
    setState(() {
      widget.iBarIndex = index;
    });
  }

  /// Dibuja el NavigationBar con sus tres destinos.
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected:BotBarItemSelected,
      // Los colores (fondo e indicador verde suave) vienen del tema global (MiApp.dart).
      selectedIndex: widget.iBarIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home_rounded),
          icon: Icon(Icons.home_outlined),
          label: 'Principal',
        ),
        NavigationDestination(
          // Badge: añade un puntito (o un número, con `label`) encima del icono.
          selectedIcon: Badge(isLabelVisible:widget.blBadge1, child: Icon(Icons.notifications_rounded)),
          icon: Badge(isLabelVisible:widget.blBadge1, child: Icon(Icons.notifications_outlined)),
          label: 'Notifications',
        ),
        NavigationDestination(
          selectedIcon: Badge(isLabelVisible:widget.sBadge2.isNotEmpty, label: Text(widget.sBadge2), child: Icon(Icons.chat_bubble_rounded)),
          icon: Badge(isLabelVisible:widget.sBadge2.isNotEmpty, label: Text(widget.sBadge2), child: Icon(Icons.chat_bubble_outline_rounded)),
          label: 'Messages',
        ),
      ],
    );

  }
}