import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class Earthquake {

  String titulo="";
  double magnitud=0.0;
  LatLng coordenada=LatLng(0, 0);
  Function(Earthquake)? onDetailsViewed;

  Earthquake(Map<String,dynamic> datos){
    this.titulo=datos["properties"]["title"];
    //print("-----_>>>>>> "+datos["properties"]["mag"]);
    this.magnitud=double.parse(datos["properties"]["mag"].toString());
    this.coordenada=LatLng(
        double.parse(datos["geometry"]["coordinates"][1].toString()),
        double.parse(datos["geometry"]["coordinates"][0].toString())
    );
  }

  void onMarkerPressed(){
    //print("SE PRESIONO UN MARKER CON TITULO "+titulo);
    onDetailsViewed!(this);
  }


}