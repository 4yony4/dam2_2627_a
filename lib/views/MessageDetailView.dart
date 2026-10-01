import 'package:dam2_2627_a/FbObjects/Mensaje.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

class Messagedetailview extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Mensaje mensaje=Dataholder.instance.mensajeSeleccionado!;

    return Scaffold(
      appBar: AppBar(
        title: Text(mensaje.titulo!),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text("Título: "+mensaje.titulo!),
            Text("Cuerpo: "+mensaje.cuerpo!),
            Text("Leído: "+mensaje.leido.toString()),
            Text("Enviado: "+mensaje.enviado!.toDate().toString()),
          ],
        ),
      ),
    );
  }

}
