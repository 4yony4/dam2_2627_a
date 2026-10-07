// =====================================================================
// OnBoardingView.dart — PANTALLA DE CARGA INICIAL (ruta "/Onboardingview")
// ---------------------------------------------------------------------
// Es la primera pantalla (initialRoute en MiApp.dart). Muestra una imagen y
// una barra de progreso mientras "carga recursos" y luego DECIDE adónde ir:
//   - Sin sesión en Firebase Auth           -> "/LoginView"
//   - Con sesión y con perfil en Firestore  -> descarga mensajes -> "/HomeView"
//   - Con sesión pero sin perfil            -> "/Profileview" (ver NOTA abajo)
// Firestore: lee "Perfiles/{uid}" (con withConverter) y empieza a escuchar
// "Perfiles/{uid}/Mensajes".
// Dataholder: ESCRIBE perfilUsuario y sMessagesBadgeText.
// Navega siempre con popAndPushNamed: esta pantalla desaparece de la pila y
// el botón "atrás" no puede volver a ella.
// =====================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/FbObjects/Perfil.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';
import '../FbObjects/Mensaje.dart';

/// Pantalla de carga. Es un StatefulWidget porque el porcentaje de progreso
/// cambia y la pantalla se tiene que redibujar cada vez.
///
/// Un StatefulWidget se reparte en dos clases: el widget (configuración,
/// inmutable) y su State (_Onboardingview), donde viven los datos que cambian.
class Onboardingview extends StatefulWidget {
  /// Constructor `const`; `super.key` permite a Flutter identificar el widget.
  const Onboardingview({ super.key });

  /// Crea el objeto State asociado a este widget.
  @override
  State<Onboardingview> createState() => _Onboardingview();
}

/// State de la pantalla de carga: progreso y lógica de arranque.
class _Onboardingview extends State<Onboardingview> {
  /// Acceso a Cloud Firestore.
  FirebaseFirestore db = FirebaseFirestore.instance;
  /// Porcentaje de progreso (0-100) que se pinta en la barra y en el texto.
  int _iProgress=0;

  /// initState() se ejecuta UNA SOLA VEZ, al crear el State (antes del primer
  /// build). Es el sitio ideal para lanzar cargas iniciales.
  /// Siempre hay que llamar primero a super.initState().
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Sin await: initState no puede ser async. cargarRecursos() avanza "por
    // su cuenta" y mientras tanto la pantalla ya se dibuja.
    cargarRecursos();

  }

  /**
   * Simula la carga de recursos (3 pasos), actualiza la barra de progreso
   * y, al terminar, decide a qué pantalla ir según la sesión y el perfil.
   *
   * Es `async`: cada `await` "pausa" este método SIN bloquear la interfaz,
   * así la barra sigue animándose mientras esperamos.
   *
   */
  void cargarRecursos() async{
    await recursos1();
    // setState(): cambiamos _iProgress Y avisamos a Flutter para que vuelva a
    // ejecutar build(); así la barra muestra el nuevo valor.
    setState(() {
      _iProgress=20;
    });
    await recursos2();
    setState(() {
      _iProgress=80;
    });
    await recursos3();
    setState(() {
      _iProgress=100;
    });

    // Al abrir directamente /HomeView en Web, esta ruta puede quedar debajo
    // de Home. En ese caso HomeProfileGate se encarga de restaurar el perfil.
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;



    // Firebase Auth recuerda la sesión entre aperturas de la app:
    // currentUser es null si nadie ha iniciado sesión.
    if(FirebaseAuth.instance.currentUser==null){
      // popAndPushNamed: quita esta pantalla y pone la de login (no hay "atrás").
      Navigator.popAndPushNamed(context, "/LoginView");
    }
    else{//SIEMPRE Y CUANDO SE HAYA LOGEADO O REGISTRO ANTES
      // `!`: aquí sabemos que currentUser no es null (estamos en el else).
      String uid=FirebaseAuth.instance.currentUser!.uid;
      print("EL UID DEL URUSARIO LOGEADO ES: "+uid);

      // withConverter: enseña a Firestore a convertir el documento en un objeto
      // Perfil (fromFirestore) y al revés (toFirestore). Así docSnap.data()
      // devuelve directamente un Perfil en vez de un Map.
      final docRef = db.collection("Perfiles").doc(uid).withConverter(
        fromFirestore: Perfil.fromFirestore,
        toFirestore: (Perfil perfil, _) => perfil.toFirestore(),
      );

      // get() lee el documento UNA sola vez (no en tiempo real). Es un Future: await.
      final docSnap = await docRef.get();
      final perfil = docSnap.data();
      if (!mounted) return;
      if (perfil == null) {
        Navigator.popAndPushNamed(context, "/Profileview");
        return;
      }
      Dataholder.instance.perfilUsuario=perfil;

      // Escucha en tiempo real el documento del perfil (ver Dataholder).
      Dataholder.instance.initFirebaseListeners();

      {
        print("HEY HEY HEY!!!!!");
        //SI TIENE PERFIL EN LA BASE DATOS
        //print("EL UID DEL URUSARIO LOGEADO ES: "+Dataholder.instance.perfilUsuario.altura.toString());
        // Empieza a escuchar los mensajes del usuario (Perfiles/{uid}/Mensajes).
        // NOTA: este `await` no espera a que lleguen los mensajes (listen() es
        // asíncrono), así que la lista puede estar todavía vacía al contarlos.
        await Dataholder.instance.perfilUsuario.descargarMensajes();

        // Contamos los mensajes no leídos para el badge de la barra inferior.
        int numNoLeido=0;
        for(Mensaje m in Dataholder.instance.perfilUsuario.mensajes){
          if(!m.leido)numNoLeido++;
        }

        // Se guarda en Dataholder para que la barra inferior de HomeView lo muestre.
        Dataholder.instance.sMessagesBadgeText=numNoLeido.toString();

        if (!mounted) return;
        Navigator.popAndPushNamed(context, "/HomeView");
      }
    }
  }

  /// Simula una carga de 1 segundo (por ejemplo, descargar configuración).
  /// Future.delayed crea un Future que se completa pasado ese tiempo.
  Future<void> recursos1() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Segunda carga simulada (1 segundo).
  Future<void> recursos2() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Tercera carga simulada (1 segundo).
  Future<void> recursos3() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Dibuja la pantalla. Se ejecuta al principio y tras cada setState().
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea: evita que el contenido quede bajo el notch o la barra de estado.
      body: SafeArea(
        // Center + SingleChildScrollView: centrado y, si no cabe (pantalla pequeña
        // o en horizontal), se puede hacer scroll en vez de desbordar.
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppEspacios.xl),
            // ConstrainedBox limita el ancho máximo (tablets) con el token anchoFormulario.
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppEspacios.anchoFormulario),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  // ClipRRect recorta la imagen con esquinas redondeadas.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadios.tarjeta),
                    child: Image.network(
                      'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                      // Si no hay conexión mostramos un icono en vez del error rojo.
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.flutter_dash, size: AppEspacios.iconoGrande*2, color: AppColores.principal),
                    ),
                  ),
                  /*Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: CircularProgressIndicator(),
                  ),*/
                  Padding(padding: EdgeInsets.fromLTRB(0, AppEspacios.xl+AppEspacios.md, 0, AppEspacios.md),
                    // TweenAnimationBuilder: la barra avanza suavemente en vez de "saltar".
                    // Anima desde el valor actual hasta `end` (_iProgress/100, entre 0 y 1) en
                    // 400 ms. Cada vez que setState cambia _iProgress, se anima el salto.
                    // `builder` se llama en cada fotograma con el valor intermedio (`valor`).
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _iProgress/100),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      builder: (context, valor, child) {
                        return LinearProgressIndicator(
                          value: valor,
                          minHeight: AppEspacios.sm,
                          borderRadius: BorderRadius.circular(AppEspacios.sm),
                        );
                      },
                    )
                  ),
                  // "$_iProgress%" es interpolación de cadenas: mete el valor dentro del texto.
                  Text("$_iProgress%", style: AppTextos.tituloLista.copyWith(color: AppColores.oscuro))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
