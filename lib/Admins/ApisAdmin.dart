import 'dart:convert';

import 'package:dam2_2627_a/APIObjects/EarthQuake.dart';
import 'package:http/http.dart' as http;


class Apisadmin {

  Future<List<Earthquake>> getEarthQuakes() async {
    print("EMPIEZO LA DESCARGA");
    // Parse the entire URI, including the scheme
    final httpPackageUrl = Uri.parse('https://earthquake.usgs.gov/'
        'fdsnws/event/1/query?'
        'format=geojson&'
        'starttime=2026-10-12&'
        'endtime=2026-10-20&'
        'minmagnitude=3');

    String httpPackageInfo = await http.read(httpPackageUrl);
    final httpPackageJson = json.decode(httpPackageInfo) as Map<String, dynamic>;
    List<Earthquake> terremotos=[];
    for(Map<String,dynamic> d in httpPackageJson["features"]){
      terremotos.add(new Earthquake(d));
    }

    return terremotos;
    //print(terremotos.length);

// Specifically create a URI with the https scheme
    //Uri.https('dart.dev', '/f/packages/http.json');
  }


}