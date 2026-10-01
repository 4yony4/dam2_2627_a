import 'package:dam2_2627_a/FbObjects/Mensaje.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

class Messagedetailview extends StatelessWidget{

  String formatearFecha(DateTime fecha){
    String dosCifras(int n) => n.toString().padLeft(2, '0');
    return dosCifras(fecha.day)+"/"+dosCifras(fecha.month)+"/"+fecha.year.toString()
        +"  ·  "+dosCifras(fecha.hour)+":"+dosCifras(fecha.minute);
  }

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
              Spacer(),
              crearEtiquetaLeido(mensaje.leido),
            ],
          ),
          SizedBox(height: AppEspacios.lg),
          Text(
            mensaje.titulo ?? "",
            style: AppTextos.tituloCabecera,
          ),
          SizedBox(height: AppEspacios.sm),
          crearFecha(mensaje),
        ],
      ),
    );
  }

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
          formatearFecha(mensaje.enviado!.toDate()),
          style: AppTextos.fecha,
        ),
      ],
    );
  }

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
          Icon(leido ? Icons.done_all_rounded : Icons.mark_email_unread_outlined, color: AppColores.sobrePrincipal, size: 14),
          SizedBox(width: AppEspacios.xs+2),
          Text(leido ? "Leído" : "No leído", style: AppTextos.etiqueta),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    Mensaje mensaje=Dataholder.instance.mensajeSeleccionado!;

    return Scaffold(
      appBar: AppBar(
        // Colores y estilo del título vienen del tema global (MiApp.dart).
        title: Text("Detalle del mensaje"),
      ),
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
