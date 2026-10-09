import 'package:dam2_2627_a/DataHolder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../insLib/bot_bars/InsBotBarStyle1.dart';

class Mapview extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    Dataholder.instance.iBotBarIndex=3;

    return Scaffold(

      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(40.4168, -3.7038), // Madrid
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.newton.dam2_2627_a',
          ),
          RichAttributionWidget(
            attributions: [TextSourceAttribution('© OpenStreetMap contributors')],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(40.5868, -3.300),
                width: 180,
                height: 180,
                child: Image.network(Dataholder.instance.perfilUsuario.urlAvatar!),
              ),
            ],
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
