import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/FbObjects/Mensaje.dart';
import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:dam2_2627_a/views/HomeView.dart';
import 'package:dam2_2627_a/views/LoginView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

class Messagesview extends StatefulWidget{
  @override
  State<Messagesview> createState() => _MessagesviewState();
}

class _MessagesviewState extends State<Messagesview> {

  FirebaseFirestore db=FirebaseFirestore.instance;
  int iNumeroMensajes=0;

  @override
  void initState() {
    super.initState();
    Dataholder.instance.iBotBarIndex=2;
    Dataholder.instance.sMessagesBadgeText="";
    Dataholder.instance.perfilUsuario.marcarMensajesLeidos();
    Dataholder.instance.perfilUsuario.setOnMessageReceived(mensajeRecibido);
    iNumeroMensajes=Dataholder.instance.perfilUsuario.mensajes.length;


  }

  Widget? creadorDeItem(BuildContext context, int indice){
    // Antes la altura era aleatoria (Random) y la lista "saltaba" en cada repintado.
    // Ahora todos los elementos tienen el mismo diseño, tipo tarjeta.
    Color color=AppColores.suave;
    String sUrlImg="https://i.pinimg.com/originals/78/1a/51/781a5128e733c6a36aa6a10814e19548.gif";
    if(indice%2==0){
      color=AppColores.divisor;
      sUrlImg="https://media.tenor.com/aGj-frNYMFEAAAAM/cat-cat-dance.gif";
    }

    return GestureDetector(
      onTap: () {
        Dataholder.instance.mensajeSeleccionado=Dataholder.instance.perfilUsuario.mensajes[indice];
        Navigator.pushNamed(context, "/MessageDetailview");
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppEspacios.md-AppEspacios.xs),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadios.imagen),
                child: Container(
                  color: color,
                  width: AppEspacios.imagenLista,
                  height: AppEspacios.imagenLista,
                  child: Image.network(
                    sUrlImg,
                    fit: BoxFit.cover,
                    // Si la imagen no carga, mostramos un icono de mensaje.
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.mail_rounded, color: AppColores.oscuro),
                  ),
                ),
              ),
              SizedBox(width: AppEspacios.md),
              // Expanded + ellipsis: los textos largos se cortan con "..." en vez de desbordar.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Dataholder.instance.perfilUsuario.mensajes[indice].titulo!,
                      style: AppTextos.tituloLista,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppEspacios.xs),
                    Text(
                      Dataholder.instance.perfilUsuario.mensajes[indice].cuerpo!,
                      style: AppTextos.secundario,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColores.textoSecundario),
            ],
          ),
        ),
      ),
    );

  }

  Widget creadorDeSeparador(BuildContext context, int indice){
      return Container(
        height: AppEspacios.md-AppEspacios.xs,
      );
  }

  Widget crearLista(){
    return ListView.separated(
        // Abajo dejamos sitio extra para que el botón flotante no tape el último mensaje.
        padding: EdgeInsets.fromLTRB(AppEspacios.md, AppEspacios.md, AppEspacios.md, AppEspacios.xl*3),
        itemCount: iNumeroMensajes,
        itemBuilder: creadorDeItem,
        //scrollDirection:Axis.horizontal
        separatorBuilder:creadorDeSeparador
    );
  }

  Widget crearGridItem(BuildContext context, int index){
    return Card(
      color: Colors.amber,
      child: Center(child: Text('$index')),
    );
  }
  
  Widget crearGrid(){
    return Container(
      height: 300,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 300,
          itemBuilder: crearGridItem
      ),
    );
  }

  void onPressedFloatingBotton() async{
    Mensaje mensajeNuevo=Mensaje.initCampos(
        "",
        "Nuevo Mensaje 1",
        "Cuerpo del nuevo mensaje",
        false,
        Timestamp.fromDate(DateTime.now()));

    setState(() {
      Dataholder.instance.perfilUsuario.agregarNuevoMensaje(mensajeNuevo);
    });
  }

  void mensajeRecibido(int iMensajesTotales){
    setState(() {
      iNumeroMensajes=iMensajesTotales;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: SafeArea(
          bottom: false,
          child: crearLista(),
        ),
        bottomNavigationBar: Insbotbarstyle1(
            blBadge1: Dataholder.instance.blNotificacionesBadge,
            sBadge2: Dataholder.instance.sMessagesBadgeText,
            iBarIndex: Dataholder.instance.iBotBarIndex
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onPressedFloatingBotton,
          tooltip: 'Add Messages',
          child: const Icon(Icons.add),
        ),
    );
  }
}