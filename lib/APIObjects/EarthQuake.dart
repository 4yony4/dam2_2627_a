import 'package:latlong2/latlong.dart';

class Earthquake {

  String titulo="";
  double magnitud=0.0;
  LatLng coordenada=LatLng(0, 0);

  Earthquake(Map<String,dynamic> datos){
    this.titulo=datos["properties"]["title"];
    //print("-----_>>>>>> "+datos["properties"]["mag"]);
    this.magnitud=double.parse(datos["properties"]["mag"].toString());
    this.coordenada=LatLng(
        double.parse(datos["geometry"]["coordinates"][0].toString()),
        double.parse(datos["geometry"]["coordinates"][1].toString())
    );
  }

}