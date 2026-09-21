import 'package:cloud_firestore/cloud_firestore.dart';

class Perfil {
  String? uid;
  String? name;
  int? edad;
  double? altura=0.0;

  Perfil({this.uid,this.name, this.edad, this.altura});

  factory Perfil.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Perfil(
      uid:snapshot.id,
      name: data?['name'] as String?,
      edad: (data?['edad'] as num?)?.toInt(),
      altura: (data?['altura'] as num?)?.toDouble(),
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
