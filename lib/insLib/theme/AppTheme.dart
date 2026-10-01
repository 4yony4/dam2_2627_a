import 'package:flutter/material.dart';

// =====================================================================
// AppTheme.dart — TOKENS DE DISEÑO (colores, espacios, radios y textos)
// ---------------------------------------------------------------------
// Los usan MiApp.crearTema() (tema global) y todas las vistas.
// Son clases con miembros `static const`: no se crean objetos, se usan
// directamente (AppColores.principal). `const` = valor fijo que se conoce
// al compilar, por eso Flutter puede reutilizarlo sin recrearlo.
// =====================================================================
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

  /// Borde de las "pastillas" sobre la cabecera verde. Es algo más opaco que
  /// [pastilla] para que el contorno se vea.
  static const Color pastillaBorde = Color.fromARGB(110, 255, 255, 255);

  /// Borde de los campos de texto cuando no tienen el foco.
  static const Color bordeCampo = Color.fromARGB(255, 205, 214, 199);

  /// Color de errores (por ejemplo, un PIN incorrecto).
  static const Color error = Color.fromARGB(255, 186, 26, 26);
}

/// Espacios (márgenes y paddings) en múltiplos de 4.
class AppEspacios {
  // Escala de espacios: xs=4, sm=8, md=16, lg=24, xl=32. Un nombre corto
  // ("md") es más fácil de recordar y de cambiar que un número suelto.
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Ancho máximo del contenido en tablets / horizontal, para que las
  /// líneas de texto no sean demasiado largas.
  static const double anchoMaximo = 720;

  /// Ancho máximo de los formularios (login, registro, perfil...).
  static const double anchoFormulario = 440;

  /// Altura mínima de botones y elementos pulsables (accesibilidad: 48dp).
  static const double alturaBoton = 48;

  /// Tamaño de los iconos decorativos grandes (cabecera de formularios).
  static const double iconoGrande = 48;

  /// Tamaño de las imágenes/iconos grandes de los elementos de una lista.
  static const double imagenLista = 56;
}

/// Radios de las esquinas redondeadas.
class AppRadios {
  // Radios de las pastillas (etiquetas), las tarjetas y la cabecera verde.
  static const double pastilla = 20;
  static const double tarjeta = 20;
  static const double cabecera = 32;

  /// Campos de texto y botones.
  static const double campo = 14;

  /// Imágenes pequeñas dentro de tarjetas (por ejemplo, en la lista de mensajes).
  static const double imagen = 12;
}

/// Estilos de texto reutilizables.
class AppTextos {
  /// Título grande blanco sobre la cabecera verde (HomeView, detalle).
  static const TextStyle tituloCabecera = TextStyle(
    color: AppColores.sobrePrincipal,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  /// Texto de la "pastilla" leído / no leído.
  static const TextStyle etiqueta = TextStyle(
    color: AppColores.sobrePrincipal,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  /// Fecha del mensaje en la cabecera del detalle.
  static const TextStyle fecha = TextStyle(
    color: AppColores.sobrePrincipalSuave,
    fontSize: 13,
  );

  /// Título de sección en mayúsculas (por ejemplo, "MENSAJE").
  static const TextStyle seccion = TextStyle(
    color: AppColores.oscuro,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  /// Cuerpo del mensaje en el detalle (interlineado amplio para leer mejor).
  static const TextStyle cuerpo = TextStyle(
    color: AppColores.texto,
    fontSize: 17,
    height: 1.6,
  );

  /// Título de la barra superior (AppBar).
  static const TextStyle tituloBarra = TextStyle(
    color: AppColores.sobrePrincipal,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  /// Título grande de una pantalla sobre fondo claro (por ejemplo, "LOGIN").
  static const TextStyle tituloPantalla = TextStyle(
    color: AppColores.oscuro,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  /// Título de un elemento de una lista.
  static const TextStyle tituloLista = TextStyle(
    color: AppColores.texto,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Texto secundario sobre fondo claro (subtítulos, descripciones cortas).
  static const TextStyle secundario = TextStyle(
    color: AppColores.textoSecundario,
    fontSize: 14,
    height: 1.4,
  );

  /// Texto de los botones.
  static const TextStyle boton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
