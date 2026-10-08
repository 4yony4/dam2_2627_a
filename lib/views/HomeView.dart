// =====================================================================
// HomeView.dart — PANTALLA PRINCIPAL (ruta "/HomeView")
// ---------------------------------------------------------------------
// Saluda al usuario y le deja cambiar su nombre (se guarda en Firestore).
// También sirve de muestrario de widgets: menú lateral (Drawer), menú
// emergente (PopupMenuButton), campo con máscara de teléfono y campo de PIN.
// Navegación:
//   - Barra inferior (Insbotbarstyle1) -> "/Messagesview"
//   - Menú "Perfil"                    -> "/EditProfileview"
//   - Logout (botón o menú "Salir")    -> cierra sesión -> "/LoginView"
// Dataholder: LEE perfilUsuario, badges e índice de la barra; ESCRIBE
// iBotBarIndex y perfilUsuario.name.
// Firestore: escribe "Perfiles/{uid}" al pulsar "Guardar".
// =====================================================================
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

/// Pantalla principal. Es un StatefulWidget porque el nombre del saludo
/// (sNombre) cambia y hay que redibujar la cabecera al guardarlo.
class Homeview extends StatefulWidget{
  /// Crea el State donde vive todo lo que cambia en esta pantalla.
  @override
  State<Homeview> createState() => _HomeviewState();
}

/// State de HomeView: datos que cambian y métodos de la pantalla.
class _HomeviewState extends State<Homeview> {
  /// BuildContext guardado en build() para navegar desde funClickLogout.
  late BuildContext miContext;

  /// Controlador del campo "NOMBRE".
  TextEditingController nombreController=TextEditingController();
  /// Nombre que se muestra en la cabecera. Se inicializa con el perfil de
  /// Dataholder (`!` porque name es String? y damos por hecho que existe).
  String sNombre=Dataholder.instance.perfilUsuario.name!;
  /// Acceso a Cloud Firestore.
  FirebaseFirestore db=FirebaseFirestore.instance;


  /// Iconos para AnimatedBottomNavigationBar (comentada al final); ahora no se usa.
  List<IconData> iconList=[
    Icons.home,
    Icons.inbox,
    Icons.settings,
    Icons.person
  ];



  /// Formateador del paquete mask_text_input_formatter: obliga al campo de
  /// teléfono a seguir el patrón '+# (###) ###-##-##', donde # es un dígito.
  MaskTextInputFormatter maskFormatter =  MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  /// Al entrar, marca "Principal" (índice 0) como pestaña activa de la barra.
  @override
  void initState() {
    super.initState();
    // Se guarda en Dataholder porque la barra se crea en build() leyendo de ahí.
    Dataholder.instance.iBotBarIndex=0;

  }

  /// Botón "Guardar": cambia el nombre en pantalla, en Dataholder y en Firestore.
  void clickActualizarNombre(){
    // setState: cambia sNombre y redibuja, así la cabecera muestra el nuevo nombre.
    setState(() {
      sNombre=nombreController.text;
    });
    Dataholder.instance.perfilUsuario.name=sNombre;

    // set() sobrescribe "Perfiles/{uid}" con el perfil completo (toFirestore).
    // NOTA: sin await ni control de errores: si falla, nadie se entera.
    db.collection("Perfiles")
        .doc(Dataholder.instance.perfilUsuario.uid)
        .set(Dataholder.instance.perfilUsuario.toFirestore());

  }

  /// Opción "Perfil" del menú: abre la pantalla de edición del perfil.
  /// `await` espera a que el usuario vuelva; entonces refrescamos el saludo
  /// por si ha cambiado el nombre.
  Future<void> funClickPerfil() async{
    await Navigator.pushNamed(miContext, "/EditProfileview");
    if(!mounted) return;
    setState(() {
      sNombre=Dataholder.instance.perfilUsuario.name ?? "";
    });
  }

  /// Cierra la sesión en Firebase Auth y vuelve al login (sin "atrás").
  void funClickLogout(){
    FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(miContext, "/LoginView");
  }

  // Cabecera verde con degradado, igual que en la vista de detalle del mensaje.
  // Es un método que devuelve un Widget: así build() queda más corto y legible.
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

  /// Menú lateral (Drawer) que se abre con el botón de menú de la AppBar.
  /// Los botones MENU1..MENU4 aún no hacen nada (onPressed vacío).
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

  /// Dibuja la pantalla principal.
  @override
  Widget build(BuildContext context) {
    // Guardamos el context para navegar desde funClickLogout.
    miContext=context;
    // NOTA: esta línea está DENTRO de build(), que se ejecuta cada vez que la
    // pantalla se redibuja (por ejemplo, tras el setState de "Guardar"). Por eso
    // el campo vuelve a "HOLA HOLA HOLA" y se pierde lo escrito. ¿Dónde debería
    // ir? (pista: initState).
    nombreController.text="HOLA HOLA HOLA";
    return Scaffold(
      appBar: AppBar(
        title: Text("HOMEVIEW"),
        actions: [
          // PopupMenuButton: menú de "tres puntos" en la AppBar. onSelected recibe
          // el `value` de la opción pulsada.
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            onSelected: (opcion) {
              if (opcion == 'buscar') print("BUSCAR");
              if (opcion == 'perfil') funClickPerfil();
              if (opcion == 'salir') funClickLogout();
            },
            // itemBuilder construye la lista de opciones cuando se abre el menú.
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
      // drawer: al indicarlo, el Scaffold añade solo el botón de menú en la AppBar.
      drawer: crearMenuLateral(),
      // SafeArea con top:false: la AppBar ya protege la parte de arriba.
      body: SafeArea(
        top: false,
        // SingleChildScrollView: al abrir el teclado se puede hacer scroll en vez de desbordar.
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppEspacios.xl),
          child: Column(
            children: [
              //if(Dataholder.instance.deviceadmin.isAndroid())
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
                              // Campo del nombre: lo escrito se guarda al pulsar "Guardar".
                              TextField(controller: nombreController,decoration: InputDecoration(hintText: "NOMBRE",prefixIcon: Icon(Icons.person_outline_rounded)),),
                              SizedBox(height: AppEspacios.md),
                              // Campo de teléfono con máscara: solo números y con formato fijo.
                              TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [maskFormatter],
                                decoration: InputDecoration(hintText: "+# (###) ###-##-##",prefixIcon: Icon(Icons.phone_outlined)),
                              ),
                              SizedBox(height: AppEspacios.lg),
                              // PinInputTextField (paquete pin_input_text_field): 4 círculos para un PIN.
                              // No se guarda en ningún sitio: es solo un ejemplo de widget.
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
      // Barra de navegación inferior propia (insLib). Le pasamos los datos de
      // Dataholder para que todas las pantallas la muestren igual.
      bottomNavigationBar:Insbotbarstyle1(
          blBadge1: Dataholder.instance.blNotificacionesBadge,
          sBadge2: Dataholder.instance.sMessagesBadgeText,
          iBarIndex: Dataholder.instance.iBotBarIndex
      )

      // Alternativa con el paquete animated_bottom_navigation_bar (comentada).
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
