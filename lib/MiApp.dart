
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

class Miapp extends StatelessWidget {
  double dbNumber=0.0;

  /// Tema global de la app. Se construye con los tokens de AppTheme.dart,
  /// así todas las pantallas (AppBar, campos de texto, botones, tarjetas...)
  /// tienen el mismo aspecto sin repetir estilos en cada vista.
  ThemeData crearTema(){
    ColorScheme colores=ColorScheme.fromSeed(
      seedColor: AppColores.principal,
      primary: AppColores.oscuro,
      onPrimary: AppColores.sobrePrincipal,
      surface: AppColores.tarjeta,
      error: AppColores.error,
    );

    BorderRadius radioCampo=BorderRadius.circular(AppRadios.campo);
    RoundedRectangleBorder formaBoton=RoundedRectangleBorder(borderRadius: radioCampo);
    Size tamanoBoton=Size(64, AppEspacios.alturaBoton);

    return ThemeData(
      colorScheme: colores,
      scaffoldBackgroundColor: AppColores.fondo,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColores.principal,
        foregroundColor: AppColores.sobrePrincipal,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextos.tituloBarra,
      ),

      cardTheme: CardThemeData(
        color: AppColores.tarjeta,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black26,
        elevation: 3,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadios.tarjeta)),
      ),

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

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColores.oscuro,
        foregroundColor: AppColores.sobrePrincipal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadios.tarjeta)),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColores.tarjeta,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColores.suave,
        elevation: 3,
        shadowColor: Colors.black26,
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: AppColores.fondo,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColores.tarjeta,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radioCampo),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColores.oscuro,
        linearTrackColor: AppColores.suave,
      ),

      dividerTheme: DividerThemeData(color: AppColores.divisor),
    );
  }

  @override
  Widget build(BuildContext context) {

    String rutaInicial="/LoginView";
    if(FirebaseAuth.instance.currentUser!=null){
      rutaInicial="/HomeView";
    }

    return new MaterialApp(
      title: "MI APP 1",
      theme: crearTema(),
      routes: {
        "/LoginView" : (context) =>  Loginview(),
        "/HomeView" : (context) =>  Homeview(),
        "/RegisterView" : (context) =>  Registerview(),
        "/Onboardingview":(context) => Onboardingview(),
        "/Profileview":(context) => Profileview(),
        "/Messagesview":(context) => Messagesview(),
        "/MessageDetailview":(context) => Messagedetailview(),

      },
      initialRoute: "/Onboardingview",
    );
  }

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
