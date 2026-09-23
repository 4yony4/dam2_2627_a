import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/DataHolder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../insLib/bot_bars/InsBotBarStyle1.dart';

class Homeview extends StatefulWidget{
  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  late BuildContext miContext;

  TextEditingController nombreController=TextEditingController();
  String sNombre=Dataholder.instance.perfilUsuario.name!;
  FirebaseFirestore db=FirebaseFirestore.instance;


  List<IconData> iconList=[
    Icons.home,
    Icons.inbox,
    Icons.settings,
    Icons.person
  ];



  MaskTextInputFormatter maskFormatter =  MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  void clickActualizarNombre(){
    setState(() {
      sNombre=nombreController.text;
    });
    Dataholder.instance.perfilUsuario.name=sNombre;

    db.collection("Perfiles")
        .doc(Dataholder.instance.perfilUsuario.uid)
        .set(Dataholder.instance.perfilUsuario.toFirestore());

  }

  void funClickLogout(){
    FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(miContext, "/LoginView");
  }

  @override
  Widget build(BuildContext context) {
    miContext=context;
    nombreController.text="HOLA HOLA HOLA";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 146, 183, 123),
        title: Text("HOMEVIEW"),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            onSelected: (opcion) {
              if (opcion == 'buscar') print("BUSCAR");
              if (opcion == 'perfil') print("PERFIL");
              if (opcion == 'salir') funClickLogout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'buscar',
                child: Row(
                  children: [Icon(Icons.search), SizedBox(width: 8), Text('Buscar')],
                ),
              ),
              PopupMenuItem(
                value: 'perfil',
                child: Row(
                  children: [Icon(Icons.person), SizedBox(width: 8), Text('Perfil')],
                ),
              ),
              PopupMenuItem(
                value: 'salir',
                child: Row(
                  children: [Icon(Icons.logout), SizedBox(width: 8), Text('Salir')],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Column(
        children: [
          TextButton(onPressed: (){}, child: Text("MENU1")),
          TextButton(onPressed: (){}, child: Text("MENU2")),
          TextButton(onPressed: (){}, child: Text("MENU3")),
          TextButton(onPressed: (){}, child: Text("MENU4"))
        ],

      ),
      body: Container(
        //width: 200,
        color: Color.fromARGB(255, 146, 183, 123),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text("BIENVENIDO "+sNombre),
            TextField(controller: nombreController,decoration: InputDecoration(hintText: "NOMBRE"),),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              decoration: InputDecoration(hintText: "+# (###) ###-##-##"),
            ),
            SizedBox(
              height: 64,
              child: PinInputTextField(
                pinLength: 4,
                keyboardType: TextInputType.number,
                decoration: CirclePinDecoration(
                  strokeColorBuilder: PinListenColorBuilder(Colors.grey, Colors.red),
                  obscureStyle: ObscureStyle(
                    isTextObscure: true,
                    obscureText: '😈',
                  ),
                ),
              ),
            ),
            TextButton(onPressed: clickActualizarNombre, child: Text("Guardar")),
            TextButton(onPressed: funClickLogout, child: Text("Logout"))
          ],
        ),
      ),
      bottomNavigationBar:Insbotbarstyle1()

      /*AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),*/
    );
  }
}
