// =====================================================================
// MessagesView.dart — LISTA DE MENSAJES (ruta "/Messagesview")
// ---------------------------------------------------------------------
// Muestra Dataholder.instance.perfilUsuario.mensajes en una lista que se
// actualiza en TIEMPO REAL:
//   Firestore (Perfiles/{uid}/Mensajes) -> Perfil.descargarMensajes (listen)
//   -> callback onMessageReceived -> mensajeRecibido() -> setState -> repinta.
// Al entrar marca todos los mensajes como leídos y vacía el badge.
// Navegación:
//   - Pulsar un mensaje -> guarda Dataholder.mensajeSeleccionado ->
//     pushNamed("/MessageDetailview"). pushNamed APILA: "atrás" vuelve aquí.
//   - Barra inferior "Principal" -> "/HomeView"
// El botón "+" crea un mensaje de ejemplo en Firestore.
// =====================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/FbObjects/Mensaje.dart';
import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:dam2_2627_a/views/HomeView.dart';
import 'package:dam2_2627_a/views/LoginView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

/// Pantalla con la lista de mensajes. Es un StatefulWidget porque el número
/// de mensajes cambia en tiempo real y la lista se tiene que redibujar.
class Messagesview extends StatefulWidget{
  /// Crea el State de la pantalla.
  @override
  State<Messagesview> createState() => _MessagesviewState();
}

/// State de MessagesView: contador de mensajes, lista y callbacks.
class _MessagesviewState extends State<Messagesview> {

  /// Acceso a Cloud Firestore.
  FirebaseFirestore db=FirebaseFirestore.instance;
  /// Número de elementos que pinta la lista (itemCount). Al cambiarlo dentro
  /// de setState, la lista se redibuja con el nuevo número.
  int iNumeroMensajes=0;

  /// Se ejecuta una vez al crear la pantalla: prepara la barra, marca los
  /// mensajes como leídos y se SUSCRIBE a los cambios de los mensajes.
  @override
  void initState() {
    super.initState();
    // Índice 2 = pestaña "Messages" de la barra inferior.
    Dataholder.instance.iBotBarIndex=2;
    // Al ver los mensajes ya no hay "no leídos": vaciamos el badge.
    Dataholder.instance.sMessagesBadgeText="";
    // Pone leido=true en cada mensaje y lo guarda en Firestore (Mensaje.update).
    Dataholder.instance.perfilUsuario.marcarMensajesLeidos();
    // CALLBACK: le damos al perfil NUESTRO método mensajeRecibido (sin
    // paréntesis: pasamos la función, no la ejecutamos). El perfil lo llamará
    // cada vez que Firestore notifique cambios en los mensajes.
    Dataholder.instance.perfilUsuario.setOnMessageReceived(mensajeRecibido);
    // Valor inicial: los mensajes que ya estuvieran descargados.
    iNumeroMensajes=Dataholder.instance.perfilUsuario.mensajes.length;


  }

  /// itemBuilder de la lista: Flutter lo llama para construir el elemento
  /// número `indice` SOLO cuando va a aparecer en pantalla (por eso las listas
  /// largas son eficientes).
  Widget? creadorDeItem(BuildContext context, int indice){
    // Antes la altura era aleatoria (Random) y la lista "saltaba" en cada repintado.
    // Ahora todos los elementos tienen el mismo diseño, tipo tarjeta.
    // Alternamos color de fondo y GIF entre filas pares e impares.
    Color color=AppColores.suave;
    String sUrlImg="https://i.pinimg.com/originals/78/1a/51/781a5128e733c6a36aa6a10814e19548.gif";
    if(indice%2==0){
      color=AppColores.divisor;
      sUrlImg="https://media.tenor.com/aGj-frNYMFEAAAAM/cat-cat-dance.gif";
    }

    // GestureDetector detecta gestos sobre su hijo; onTap = toque simple.
    return GestureDetector(
      onTap: () {
        // Guardamos en Dataholder el mensaje pulsado para que la pantalla de
        // detalle sepa cuál mostrar (así no hace falta pasar argumentos a la ruta).
        Dataholder.instance.mensajeSeleccionado=Dataholder.instance.perfilUsuario.mensajes[indice];
        // pushNamed APILA el detalle encima de esta lista: con "atrás" se vuelve
        // aquí. (popAndPushNamed, en cambio, sustituiría esta pantalla.)
        Navigator.pushNamed(context, "/MessageDetailview");
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppEspacios.md-AppEspacios.xs),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadios.imagen),
                child: Container(
                  color: color,
                  width: AppEspacios.imagenLista,
                  height: AppEspacios.imagenLista,
                  child: Image.network(
                    sUrlImg,
                    fit: BoxFit.cover,
                    // Si la imagen no carga, mostramos un icono de mensaje.
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.mail_rounded, color: AppColores.oscuro),
                  ),
                ),
              ),
              SizedBox(width: AppEspacios.md),
              // Expanded + ellipsis: los textos largos se cortan con "..." en vez de desbordar.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // `!`: damos por hecho que el mensaje tiene título; si fuera null, fallaría.
                      Dataholder.instance.perfilUsuario.mensajes[indice].titulo!,
                      style: AppTextos.tituloLista,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppEspacios.xs),
                    Text(
                      Dataholder.instance.perfilUsuario.mensajes[indice].cuerpo!,
                      style: AppTextos.secundario,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColores.textoSecundario),
            ],
          ),
        ),
      ),
    );

  }

  /// separatorBuilder: construye lo que va ENTRE dos elementos (aquí, un hueco).
  Widget creadorDeSeparador(BuildContext context, int indice){
      return Container(
        height: AppEspacios.md-AppEspacios.xs,
      );
  }

  /// Crea la lista con ListView.separated: como ListView.builder pero con
  /// separadores. itemCount dice cuántos elementos hay; itemBuilder y
  /// separatorBuilder son funciones que Flutter llama para cada posición.
  Widget crearLista(){
    return ListView.separated(
        // Abajo dejamos sitio extra para que el botón flotante no tape el último mensaje.
        padding: EdgeInsets.fromLTRB(AppEspacios.md, AppEspacios.md, AppEspacios.md, AppEspacios.xl*3),
        itemCount: iNumeroMensajes,
        itemBuilder: creadorDeItem,
        //scrollDirection:Axis.horizontal
        separatorBuilder:creadorDeSeparador
    );
  }

  /// Elemento de ejemplo para la cuadrícula de crearGrid().
  Widget crearGridItem(BuildContext context, int index){
    return Card(
      color: Colors.amber,
      child: Center(child: Text('$index')),
    );
  }
  
  // NOTA: este método no se usa en ninguna parte (build() solo llama a crearLista).
  /// Ejemplo de GridView.builder: cuadrícula de 3 columnas con 300 elementos.
  Widget crearGrid(){
    return Container(
      height: 300,
      child: GridView.builder(
          // gridDelegate decide la forma de la cuadrícula: aquí, 3 columnas fijas.
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 300,
          itemBuilder: crearGridItem
      ),
    );
  }

  /// Botón flotante "+": crea un mensaje de ejemplo y lo sube a Firestore.
  /// El uid va vacío ("") porque Firestore asigna el id al hacer add().
  void onPressedFloatingBotton() async{
    Mensaje mensajeNuevo=Mensaje.initCampos(
        "",
        "Nuevo Mensaje 1",
        "Cuerpo del nuevo mensaje",
        false,
        Timestamp.fromDate(DateTime.now()));

    // agregarNuevoMensaje lo añade a la lista local y a Firestore. El listener
    // en tiempo real también recibirá el cambio y llamará a mensajeRecibido.
    setState(() {
      Dataholder.instance.perfilUsuario.agregarNuevoMensaje(mensajeNuevo);
    });
  }

  /// Método que el Perfil llama (callback) cuando cambian los mensajes en
  /// Firestore. Con setState actualizamos el contador y la lista se redibuja.
  // NOTA: nunca se "desuscribe" (no hay dispose()): si llega un cambio estando
  // en otra pantalla, se llamaría a setState de un State ya destruido.
  void mensajeRecibido(int iMensajesTotales){
    setState(() {
      iNumeroMensajes=iMensajesTotales;
    });
  }
  
  /// Dibuja la pantalla: lista + barra inferior + botón flotante.
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        // SafeArea con bottom:false: abajo ya está la barra de navegación.
        body: SafeArea(
          bottom: false,
          child: crearLista(),
        ),
        bottomNavigationBar: Insbotbarstyle1(
            blBadge1: Dataholder.instance.blNotificacionesBadge,
            sBadge2: Dataholder.instance.sMessagesBadgeText,
            iBarIndex: Dataholder.instance.iBotBarIndex
        ),
        // floatingActionButton: botón redondo flotante; su estilo viene del tema.
        floatingActionButton: FloatingActionButton(
          onPressed: onPressedFloatingBotton,
          tooltip: 'Add Messages',
          child: const Icon(Icons.add),
        ),
    );
  }
}