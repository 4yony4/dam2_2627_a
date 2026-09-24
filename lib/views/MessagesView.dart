import 'dart:math';

import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';
import 'package:dam2_2627_a/views/HomeView.dart';
import 'package:dam2_2627_a/views/LoginView.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

class Messagesview extends StatefulWidget{
  @override
  State<Messagesview> createState() => _MessagesviewState();
}

class _MessagesviewState extends State<Messagesview> {

  @override
  void initState() {
    super.initState();
    Dataholder.instance.iBotBarIndex=2;
    Dataholder.instance.sMessagesBadgeText="";

  }

  Widget? creadorDeItem(BuildContext context, int indice){
    Color color=Colors.cyanAccent;
    double altura=15+Random().nextDouble()*100;
    String sUrlImg="https://i.pinimg.com/originals/78/1a/51/781a5128e733c6a36aa6a10814e19548.gif";
    if(indice%2==0){
      color=Colors.deepOrangeAccent;
      sUrlImg="https://media.tenor.com/aGj-frNYMFEAAAAM/cat-cat-dance.gif";
    }

    return Container(
      color: color,
      height: altura,
      child: Row(
        children: [
          Image.network(sUrlImg),
          Text("ITEM "+indice.toString()),
        ],
      )
    );

  }

  Widget creadorDeSeparador(BuildContext context, int indice){
      return Container(
        height: 10,
      );
  }

  Widget crearLista(){
    return ListView.separated(
        itemCount: 25,
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
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 300,
        itemBuilder: crearGridItem
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: crearGrid(),
        bottomNavigationBar: Insbotbarstyle1(
            blBadge1: Dataholder.instance.blNotificacionesBadge,
            sBadge2: Dataholder.instance.sMessagesBadgeText,
            iBarIndex: Dataholder.instance.iBotBarIndex
        ),
    );
  }
}