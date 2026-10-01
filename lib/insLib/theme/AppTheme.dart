import 'package:flutter/material.dart';

/// Tokens de diseño de la app (colores, espacios, radios y textos).
///
/// En vez de escribir números y colores "a mano" en cada vista, se usan
/// estas constantes. Así, si cambiamos un valor aquí, cambia en toda la app.
///
/// Ejemplo de uso:
///   padding: EdgeInsets.all(AppEspacios.md)
///   color: AppColores.principal
class AppColores {
  /// Verde de marca (el mismo que usa HomeView).
  static const Color principal = Color.fromARGB(255, 146, 183, 123);

  /// Verde oscuro: degradados, iconos y textos destacados.
  static const Color oscuro = Color.fromARGB(255, 70, 110, 60);

  /// Verde muy claro: fondos suaves de iconos y etiquetas.
  static const Color suave = Color.fromARGB(255, 226, 238, 218);

  /// Fondo general de las pantallas (blanco roto verdoso).
  static const Color fondo = Color.fromARGB(255, 243, 246, 240);

  /// Fondo de tarjetas.
  static const Color tarjeta = Colors.white;

  /// Texto principal sobre fondo claro.
  static const Color texto = Color.fromARGB(255, 33, 37, 31);

  /// Texto secundario (fechas, etiquetas) sobre fondo claro.
  static const Color textoSecundario = Color.fromARGB(255, 104, 112, 100);

  /// Texto sobre fondo de color (cabeceras verdes).
  static const Color sobrePrincipal = Colors.white;

  /// Texto secundario sobre fondo de color.
  static const Color sobrePrincipalSuave = Color.fromARGB(220, 255, 255, 255);

  /// Fondo translúcido para "pastillas" sobre la cabecera verde.
  static const Color pastilla = Color.fromARGB(56, 255, 255, 255);

  /// Color de líneas divisorias.
  static const Color divisor = Color.fromARGB(255, 228, 233, 224);
}

/// Espacios (márgenes y paddings) en múltiplos de 4.
class AppEspacios {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Ancho máximo del contenido en tablets / horizontal, para que las
  /// líneas de texto no sean demasiado largas.
  static const double anchoMaximo = 720;
}

/// Radios de las esquinas redondeadas.
class AppRadios {
  static const double pastilla = 20;
  static const double tarjeta = 20;
  static const double cabecera = 32;
}

/// Estilos de texto reutilizables.
class AppTextos {
  static const TextStyle tituloCabecera = TextStyle(
    color: AppColores.sobrePrincipal,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  static const TextStyle etiqueta = TextStyle(
    color: AppColores.sobrePrincipal,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle fecha = TextStyle(
    color: AppColores.sobrePrincipalSuave,
    fontSize: 13,
  );

  static const TextStyle seccion = TextStyle(
    color: AppColores.oscuro,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static const TextStyle cuerpo = TextStyle(
    color: AppColores.texto,
    fontSize: 17,
    height: 1.6,
  );
}
