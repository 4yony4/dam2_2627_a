import 'package:cloud_firestore/cloud_firestore.dart';

class Transaccion {

  String sUid="";
  String sEstado="Incomplete";
  String sClientSecret="";
  int iCents=0;
  String sCurrency="eur";

  Transaccion({required this.sUid, required this.sEstado, required this.sClientSecret,
    required this.iCents, required this.sCurrency});

  factory Transaccion.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    if(data==null){
      return Transaccion(sUid:"",sEstado:"Incomplete",sClientSecret:"",iCents: 0,sCurrency: "eur");
    }

    return Transaccion(
      sUid:snapshot.id,
      sEstado: (data['sEstado']!=null) ? data['sEstado'] as String:"Incomplete",
      sClientSecret:(data['sClientSecret']!=null) ? data['sClientSecret'] as String:"",
      iCents:(data['iCents']!=null) ? data['iCents'] as int:0,
      sCurrency:(data['sCurrency']!=null) ? data['sCurrency'] as String:"eur",
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (sEstado != null) "sEstado": sEstado,
      if (sClientSecret != null) "sClientSecret": sClientSecret,
      if (iCents != null) "iCents": iCents,
      if (sCurrency != null) "sCurrency": sCurrency,
    };
  }
}