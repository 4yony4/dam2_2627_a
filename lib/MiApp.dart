
// =====================================================================
// MiApp.dart — WIDGET RAÍZ: RUTAS CON NOMBRE + TEMA GLOBAL
// ---------------------------------------------------------------------
// Miapp construye el MaterialApp, el "contenedor" de toda la app:
//  - Registra todas las pantallas como RUTAS CON NOMBRE ("/LoginView",
//    "/HomeView"...). Así cualquier vista puede navegar con
//    Navigator.pushNamed(context, "/HomeView") sin conocer la clase.
//  - Define el TEMA GLOBAL (crearTema) a partir de los tokens de
//    AppTheme.dart, para que todas las pantallas compartan colores,
//    bordes y botones sin repetir estilos.
//  - Marca "/Onboardingview" como primera pantalla (initialRoute).
// No usa Dataholder ni Firestore; solo consulta FirebaseAuth para calcular
// rutaInicial (ver NOTA en build()).
// =====================================================================
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:dam2_2627_a/views/HomeView.dart';
import 'package:dam2_2627_a/views/LoginView.dart';
import 'package:dam2_2627_a/views/MessageDetailView.dart';
import 'package:dam2_2627_a/views/MessagesView.dart';
import 'package:dam2_2627_a/views/RegisterView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/OnBoardingView.dart';
import 'views/ProfileView.dart';

/// Widget raíz de la aplicación (lo lanza runApp() en main.dart).
///
/// Es un StatelessWidget porque no guarda nada que cambie: solo configura
/// la app (rutas y tema). Los datos que cambian viven en el State de cada
/// pantalla o en el singleton Dataholder.
class Miapp extends StatelessWidget {
  // NOTA: variable sin uso (resto de pruebas). Además, en un StatelessWidget
  // los campos deberían ser `final` (el analizador avisa con must_be_immutable).
  double dbNumber=0.0;

  /// Tema global de la app. Se construye con los tokens de AppTheme.dart,
  /// así todas las pantallas (AppBar, campos de texto, botones, tarjetas...)
  /// tienen el mismo aspecto sin repetir estilos en cada vista.
  ///
  /// ThemeData es el "libro de estilo" de Material: cada widget (AppBar, Card,
  /// TextField, FilledButton...) busca aquí su aspecto por defecto. Por eso en
  /// las vistas casi no hay colores escritos a mano: los ponemos una vez aquí.
  ThemeData crearTema(){
    // ColorScheme.fromSeed genera una paleta completa a partir de un color
    // "semilla"; después fijamos a mano los colores que nos interesan.
    ColorScheme colores=ColorScheme.fromSeed(
      seedColor: AppColores.principal,
      primary: AppColores.oscuro,
      onPrimary: AppColores.sobrePrincipal,
      surface: AppColores.tarjeta,
      error: AppColores.error,
    );

    // Valores que se reutilizan en varios componentes (campos y botones).
    BorderRadius radioCampo=BorderRadius.circular(AppRadios.campo);
    RoundedRectangleBorder formaBoton=RoundedRectangleBorder(borderRadius: radioCampo);
    Size tamanoBoton=Size(64, AppEspacios.alturaBoton);

    return ThemeData(
      colorScheme: colores,
      scaffoldBackgroundColor: AppColores.fondo,

      // Barra superior: verde de marca, sin sombra y con el título en blanco.
      appBarTheme: AppBarTheme(
        backgroundColor: AppColores.principal,
        foregroundColor: AppColores.sobrePrincipal,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextos.tituloBarra,
      ),

      // Tarjetas (Card): blancas, esquinas redondeadas y sombra suave.
      cardTheme: CardThemeData(
        color: AppColores.tarjeta,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black26,
        elevation: 3,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadios.tarjeta)),
      ),

      // Campos de texto (TextField): fondo relleno, borde gris y borde verde
      // oscuro cuando tienen el foco (el usuario está escribiendo en ellos).
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColores.fondo,
        hintStyle: TextStyle(color: AppColores.textoSecundario),
        prefixIconColor: AppColores.oscuro,
        contentPadding: EdgeInsets.symmetric(horizontal: AppEspacios.md, vertical: AppEspacios.md),
        enabledBorder: OutlineInputBorder(
          borderRadius: radioCampo,
          borderSide: BorderSide(color: AppColores.bordeCampo),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radioCampo,
          borderSide: BorderSide(color: AppColores.oscuro, width: 2),
        ),
        border: OutlineInputBorder(borderRadius: radioCampo),
      ),

      // Los tres tipos de botón: FilledButton (acción principal), OutlinedButton
      // (acción secundaria) y TextButton (acción terciaria, tipo enlace).
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColores.oscuro,
          foregroundColor: AppColores.sobrePrincipal,
          minimumSize: tamanoBoton,
          shape: formaBoton,
          textStyle: AppTextos.boton,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColores.oscuro,
          minimumSize: tamanoBoton,
          shape: formaBoton,
          side: BorderSide(color: AppColores.oscuro),
          textStyle: AppTextos.boton,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColores.oscuro,
          minimumSize: tamanoBoton,
          shape: formaBoton,
          textStyle: AppTextos.boton,
        ),
      ),

      // Botón flotante (el "+" de MessagesView).
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColores.oscuro,
        foregroundColor: AppColores.sobrePrincipal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadios.tarjeta)),
      ),

      // Barra de navegación inferior (Insbotbarstyle1 usa un NavigationBar).
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColores.tarjeta,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColores.suave,
        elevation: 3,
        shadowColor: Colors.black26,
      ),

      // Menú lateral (Drawer de HomeView) y menú emergente (PopupMenuButton).
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColores.fondo,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColores.tarjeta,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radioCampo),
      ),

      // Barra de progreso de OnBoardingView.
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColores.oscuro,
        linearTrackColor: AppColores.suave,
      ),

      dividerTheme: DividerThemeData(color: AppColores.divisor),
    );
  }

  /// Construye el MaterialApp: título, tema y tabla de rutas con nombre.
  /// Flutter llama a build() cada vez que necesita dibujar este widget.
  @override
  Widget build(BuildContext context) {

    // NOTA: aquí se calcula rutaInicial según haya o no un usuario con sesión
    // iniciada (FirebaseAuth.instance.currentUser != null)... pero después
    // initialRoute está fijado a "/Onboardingview" y rutaInicial NO se usa.
    // Quien decide de verdad si ir a Login o a Home es OnBoardingView.
    String rutaInicial="/LoginView";
    if(FirebaseAuth.instance.currentUser!=null){
      rutaInicial="/HomeView";
    }

    // MaterialApp: da navegación, tema y estilo Material a toda la app.
    // (`new` es opcional en Dart moderno; no cambia nada.)
    return new MaterialApp(
      title: "MI APP 1",
      theme: crearTema(),
      // RUTAS CON NOMBRE: un mapa "nombre de ruta -> función que crea la pantalla".
      // Navigator.pushNamed / popAndPushNamed usan estas claves, que deben
      // escribirse EXACTAMENTE igual (mayúsculas incluidas).
      routes: {
        "/LoginView" : (context) =>  Loginview(),
        "/HomeView" : (context) =>  Homeview(),
        "/RegisterView" : (context) =>  Registerview(),
        "/Onboardingview":(context) => Onboardingview(),
        "/Profileview":(context) => Profileview(),
        "/Messagesview":(context) => Messagesview(),
        "/MessageDetailview":(context) => Messagedetailview(),

      },
      // Primera pantalla que se muestra al arrancar la app.
      initialRoute: "/Onboardingview",
    );
  }

  // Versión antigua de build() con un ejemplo de CarouselView. Está dentro
  // de un comentario /* ... */, así que el compilador la ignora.
  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Scaffold(
        body: CarouselView(
          scrollDirection: Axis.vertical,
          itemExtent: double.infinity,
          children: List<Widget>.generate(10, (int index) {
            return Center(child: Text('Item $index'));
          }),
        ),
      ),
    );

  }
*/
  
}
