// =====================================================================
// MessageDetailView.dart — DETALLE DE UN MENSAJE (ruta "/MessageDetailview")
// ---------------------------------------------------------------------
// Muestra el mensaje que MessagesView guardó en
// Dataholder.instance.mensajeSeleccionado: cabecera verde con título,
// estado (leído / no leído) y fecha, y una tarjeta con el cuerpo.
// Se llega con Navigator.pushNamed, así que la flecha "atrás" de la AppBar
// (Flutter la añade sola) vuelve a la lista de mensajes.
// Solo LEE de Dataholder; no toca Firestore.
// =====================================================================
import 'package:dam2_2627_a/FbObjects/Mensaje.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

/// Pantalla de detalle. Es un StatelessWidget porque solo muestra datos y no
/// cambia nada mientras está abierta (la animación de entrada la gestiona
/// internamente TweenAnimationBuilder).
class Messagedetailview extends StatelessWidget{

  /// Convierte un DateTime en texto "dd/mm/aaaa  ·  hh:mm".
  String formatearFecha(DateTime fecha){
    // Función local (definida dentro de otra): rellena con ceros (7 -> "07").
    String dosCifras(int n) => n.toString().padLeft(2, '0');
    return dosCifras(fecha.day)+"/"+dosCifras(fecha.month)+"/"+fecha.year.toString()
        +"  ·  "+dosCifras(fecha.hour)+":"+dosCifras(fecha.minute);
  }

  /// Cabecera verde con degradado: icono, etiqueta leído/no leído, título y fecha.
  Widget crearCabecera(Mensaje mensaje){
    return Container(
      width: double.infinity,
      // Abajo dejamos espacio extra porque la tarjeta del cuerpo "se monta" encima.
      padding: EdgeInsets.fromLTRB(AppEspacios.lg, AppEspacios.md, AppEspacios.lg, AppEspacios.xl+AppEspacios.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColores.principal, AppColores.oscuro],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadios.cabecera)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              crearIcono(),
              // Spacer ocupa todo el hueco libre: empuja la etiqueta hacia la derecha.
              Spacer(),
              crearEtiquetaLeido(mensaje.leido),
            ],
          ),
          SizedBox(height: AppEspacios.lg),
          Text(
            // `??`: si titulo es null, usa "" (evita mostrar "null" o fallar).
            mensaje.titulo ?? "",
            style: AppTextos.tituloCabecera,
          ),
          SizedBox(height: AppEspacios.sm),
          crearFecha(mensaje),
        ],
      ),
    );
  }

  /// Icono circular blanco con sombra.
  Widget crearIcono(){
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColores.tarjeta,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Icon(Icons.mail_rounded, color: AppColores.oscuro, size: 28),
    );
  }

  /// Fecha de envío. Si no hay fecha, devuelve un widget vacío (SizedBox.shrink).
  Widget crearFecha(Mensaje mensaje){
    if(mensaje.enviado==null){
      return SizedBox.shrink();
    }
    // Wrap en vez de Row: si la pantalla es estrecha, baja de línea en vez de desbordar.
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppEspacios.xs,
      children: [
        Icon(Icons.schedule_rounded, color: AppColores.sobrePrincipalSuave, size: 16),
        Text(
          // `enviado!`: ya comprobamos arriba que no es null.
          // toDate() convierte el Timestamp de Firestore en un DateTime de Dart.
          formatearFecha(mensaje.enviado!.toDate()),
          style: AppTextos.fecha,
        ),
      ],
    );
  }

  /// "Pastilla" que indica si el mensaje está leído o no.
  Widget crearEtiquetaLeido(bool leido){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppEspacios.md-AppEspacios.xs, vertical: AppEspacios.xs+2),
      decoration: BoxDecoration(
        color: AppColores.pastilla,
        borderRadius: BorderRadius.circular(AppRadios.pastilla),
        border: Border.all(color: AppColores.pastillaBorde),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Operador ternario: condición ? valorSiTrue : valorSiFalse.
          Icon(leido ? Icons.done_all_rounded : Icons.mark_email_unread_outlined, color: AppColores.sobrePrincipal, size: 14),
          SizedBox(width: AppEspacios.xs+2),
          Text(leido ? "Leído" : "No leído", style: AppTextos.etiqueta),
        ],
      ),
    );
  }

  /// Tarjeta blanca con el cuerpo del mensaje.
  Widget crearCuerpo(Mensaje mensaje){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppEspacios.md+AppEspacios.xs),
      padding: EdgeInsets.all(AppEspacios.lg),
      decoration: BoxDecoration(
        color: AppColores.tarjeta,
        borderRadius: BorderRadius.circular(AppRadios.tarjeta),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppEspacios.sm-2),
                decoration: BoxDecoration(
                  color: AppColores.suave,
                  borderRadius: BorderRadius.circular(AppEspacios.sm),
                ),
                child: Icon(Icons.notes_rounded, color: AppColores.oscuro, size: 18),
              ),
              SizedBox(width: AppEspacios.sm+2),
              Text("MENSAJE", style: AppTextos.seccion),
            ],
          ),
          Divider(height: AppEspacios.xl, color: AppColores.divisor),
          // SelectableText permite al usuario copiar el texto del mensaje.
          SelectableText(
            mensaje.cuerpo ?? "",
            style: AppTextos.cuerpo,
          ),
        ],
      ),
    );
  }

  // Animación de entrada sencilla: aparece y sube un poco al abrir la pantalla.
  // TweenAnimationBuilder anima un valor de 0 a 1 en 450 ms y llama a builder
  // en cada fotograma: lo usamos como opacidad y desplazamiento vertical.
  // `child` se construye una sola vez y se reutiliza (más eficiente).
  Widget animarEntrada(Widget hijo){
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      child: hijo,
      builder: (context, valor, child) {
        return Opacity(
          opacity: valor,
          child: Transform.translate(
            offset: Offset(0, 24*(1-valor)),
            child: child,
          ),
        );
      },
    );
  }

  /// Dibuja la pantalla de detalle.
  @override
  Widget build(BuildContext context) {
    // Leemos el mensaje elegido en la lista. `!` porque es Mensaje?: si se
    // abriera esta ruta sin haber elegido un mensaje, la app fallaría.
    Mensaje mensaje=Dataholder.instance.mensajeSeleccionado!;

    return Scaffold(
      appBar: AppBar(
        // Colores y estilo del título vienen del tema global (MiApp.dart).
        title: Text("Detalle del mensaje"),
      ),
      // SafeArea + SingleChildScrollView: respeta el notch y permite hacer scroll
      // si el mensaje es largo.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppEspacios.xl),
          child: Column(
            children: [
              crearCabecera(mensaje),
              // En tablets u horizontal limitamos el ancho para que se lea mejor.
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppEspacios.anchoMaximo),
                  child: Transform.translate(
                    // La tarjeta sube y se solapa con la cabecera.
                    offset: Offset(0, -AppEspacios.lg),
                    child: animarEntrada(crearCuerpo(mensaje)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
