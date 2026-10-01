import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/DataHolder.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
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

  @override
  void initState() {
    super.initState();
    Dataholder.instance.iBotBarIndex=0;

  }

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

  // Cabecera verde con degradado, igual que en la vista de detalle del mensaje.
  Widget crearCabecera(){
    return Container(
      width: double.infinity,
      // Abajo dejamos espacio extra porque la tarjeta del formulario "se monta" encima.
      padding: EdgeInsets.fromLTRB(AppEspacios.lg, AppEspacios.lg, AppEspacios.lg, AppEspacios.xl+AppEspacios.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColores.principal, AppColores.oscuro],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadios.cabecera)),
      ),
      child: Text("BIENVENIDO "+sNombre, style: AppTextos.tituloCabecera),
    );
  }

  Widget crearMenuLateral(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColores.principal, AppColores.oscuro],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Icon(Icons.account_circle_rounded, size: AppEspacios.iconoGrande+AppEspacios.md, color: AppColores.sobrePrincipal),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppEspacios.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(onPressed: (){}, style: estiloBotonMenu(), child: Text("MENU1")),
                TextButton(onPressed: (){}, style: estiloBotonMenu(), child: Text("MENU2")),
                TextButton(onPressed: (){}, style: estiloBotonMenu(), child: Text("MENU3")),
                TextButton(onPressed: (){}, style: estiloBotonMenu(), child: Text("MENU4"))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Los botones del menú lateral van alineados a la izquierda, como en una lista.
  ButtonStyle estiloBotonMenu(){
    return TextButton.styleFrom(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: AppEspacios.md),
    );
  }

  @override
  Widget build(BuildContext context) {
    miContext=context;
    nombreController.text="HOLA HOLA HOLA";
    return Scaffold(
      appBar: AppBar(
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
                  children: [Icon(Icons.search, color: AppColores.oscuro), SizedBox(width: AppEspacios.sm+AppEspacios.xs), Text('Buscar')],
                ),
              ),
              PopupMenuItem(
                value: 'perfil',
                child: Row(
                  children: [Icon(Icons.person, color: AppColores.oscuro), SizedBox(width: AppEspacios.sm+AppEspacios.xs), Text('Perfil')],
                ),
              ),
              PopupMenuItem(
                value: 'salir',
                child: Row(
                  children: [Icon(Icons.logout, color: AppColores.oscuro), SizedBox(width: AppEspacios.sm+AppEspacios.xs), Text('Salir')],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: crearMenuLateral(),
      body: SafeArea(
        top: false,
        // SingleChildScrollView: al abrir el teclado se puede hacer scroll en vez de desbordar.
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppEspacios.xl),
          child: Column(
            children: [
              crearCabecera(),
              // En tablets u horizontal limitamos el ancho del formulario.
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppEspacios.anchoFormulario+AppEspacios.xl),
                  child: Transform.translate(
                    // La tarjeta sube y se solapa con la cabecera.
                    offset: Offset(0, -AppEspacios.xl),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppEspacios.md),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(AppEspacios.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(controller: nombreController,decoration: InputDecoration(hintText: "NOMBRE",prefixIcon: Icon(Icons.person_outline_rounded)),),
                              SizedBox(height: AppEspacios.md),
                              TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [maskFormatter],
                                decoration: InputDecoration(hintText: "+# (###) ###-##-##",prefixIcon: Icon(Icons.phone_outlined)),
                              ),
                              SizedBox(height: AppEspacios.lg),
                              SizedBox(
                                height: 64,
                                child: PinInputTextField(
                                  pinLength: 4,
                                  keyboardType: TextInputType.number,
                                  decoration: CirclePinDecoration(
                                    strokeColorBuilder: PinListenColorBuilder(AppColores.oscuro, AppColores.bordeCampo),
                                    bgColorBuilder: FixedColorBuilder(AppColores.fondo),
                                    obscureStyle: ObscureStyle(
                                      isTextObscure: true,
                                      obscureText: '😈',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppEspacios.lg),
                              FilledButton(onPressed: clickActualizarNombre, child: Text("Guardar")),
                              SizedBox(height: AppEspacios.sm),
                              OutlinedButton(onPressed: funClickLogout, child: Text("Logout"))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:Insbotbarstyle1(
          blBadge1: Dataholder.instance.blNotificacionesBadge,
          sBadge2: Dataholder.instance.sMessagesBadgeText,
          iBarIndex: Dataholder.instance.iBotBarIndex
      )

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
