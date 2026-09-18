import 'package:cloud_firestore/cloud_firestore.dart';

class Perfil {

  final String? name;
  final int? edad;
  final double? altura;

  Perfil({this.name, this.edad, this.altura});

  factory Perfil.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Perfil(
      name: data?['name'],
      edad: data?['edad'],
      altura: data?['altura'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (edad != null) "edad": edad,
      if (altura != null) "altura": altura,
    };
  }


}