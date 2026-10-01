import 'package:dam2_2627_a/FbObjects/Mensaje.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

class Messagedetailview extends StatelessWidget{

  final Color colorPrincipal=Color.fromARGB(255, 146, 183, 123);
  final Color colorOscuro=Color.fromARGB(255, 70, 110, 60);

  String formatearFecha(DateTime fecha){
    String dosCifras(int n) => n.toString().padLeft(2, '0');
    return dosCifras(fecha.day)+"/"+dosCifras(fecha.month)+"/"+fecha.year.toString()
        +"  ·  "+dosCifras(fecha.hour)+":"+dosCifras(fecha.minute);
  }

  Widget crearCabecera(Mensaje mensaje){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorPrincipal, colorOscuro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.mail_rounded, color: colorOscuro, size: 30),
          ),
          SizedBox(height: 16),
          Text(
            mensaje.titulo!,
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              crearEtiquetaLeido(mensaje.leido),
              SizedBox(width: 12),
              Icon(Icons.schedule, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Text(
                formatearFecha(mensaje.enviado!.toDate()),
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget crearEtiquetaLeido(bool leido){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(leido ? Icons.done_all : Icons.mark_email_unread_outlined, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(leido ? "Leído" : "No leído", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget crearCuerpo(Mensaje mensaje){
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "MENSAJE",
              style: TextStyle(color: colorOscuro, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            Divider(height: 24),
            Text(
              mensaje.cuerpo!,
              style: TextStyle(fontSize: 17, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Mensaje mensaje=Dataholder.instance.mensajeSeleccionado!;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 246, 240),
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text("Detalle del mensaje"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            crearCabecera(mensaje),
            crearCuerpo(mensaje),
          ],
        ),
      ),
    );
  }

}
