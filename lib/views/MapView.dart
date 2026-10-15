import 'package:dam2_2627_a/DataHolder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../insLib/bot_bars/InsBotBarStyle1.dart';

class Mapview extends StatefulWidget{


  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {

  List<Marker> marcadores=<Marker>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Dataholder.instance.iBotBarIndex=3;
    Dataholder.instance.firebaseadmin.descargarPOIs();
    descargarDatos();

  }

  void descargarDatos() async{
    Position position=await Dataholder.instance.gpsadmin.determinePosition();
    //print("---->>>>>> "+position.toString());

    List<Marker> mtemp=await Dataholder.instance.firebaseadmin.descargarPOIs();

    setState(()  {
      marcadores=mtemp;
    });
    Dataholder.instance.firebaseadmin.onMarkersChanged(funLambdaMarcadores);//suscripcion a los listenes de markers
    Dataholder.instance.gpsadmin.realTimePosition(funLambdaGPS);
  }

  void funLambdaMarcadores(List<Marker> marcadores){
    //print("HA LLEGADO NUEVAS DATOS DE LA BASE DE DATOS");
    setState(()  {
      this.marcadores=marcadores;
    });
  }

  void funLambdaGPS(Position position){
    //print("POSICION AHORA ES: ---->>>>>> "+position.toString());
    Dataholder.instance.firebaseadmin.actualizarGPSPerfil(
        Dataholder.instance.perfilUsuario.uid,
        position,""
    );
  }

  /*
  Road: https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}
  Hybrid: https://mt.google.com/vt/lyrs=y&x={x}&y={y}&z={z}
  Satellite: https://mt.google.com/vt/lyrs=s&x={x}&y={y}&z={z}
  Other types available: see https://stackoverflow.com/a/33023651/11846040
   */
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(40.4168, -3.7038), // Madrid
          initialZoom: 5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.newton.dam2_2627_a',
          ),
          /*RichAttributionWidget(
            attributions: [TextSourceAttribution('© OpenStreetMap contributors')],
          ),*/
          MarkerLayer(
            markers: marcadores,
          ),
        ],
      ),
      bottomNavigationBar: Insbotbarstyle1(
          blBadge1: Dataholder.instance.blNotificacionesBadge,
          sBadge2: Dataholder.instance.sMessagesBadgeText,
          iBarIndex: Dataholder.instance.iBotBarIndex
      ),
    );

  }
}
