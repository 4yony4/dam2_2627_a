
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Mensaje recibido en segundo plano: ${message.messageId}');
}

class Fcmadmin {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> iniciar() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler,);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_mostrarMensajeEnPrimerPlano);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notificación abierta: ${message.messageId}');
    });
  }

  void _mostrarMensajeEnPrimerPlano(RemoteMessage message) {
    final titulo = message.notification?.title ?? 'Nueva notificación';
    final texto = message.notification?.body ?? '';

    final contenido = texto.isEmpty ? titulo : '$titulo\n$texto';

    print(contenido);

  }


  Future<void> comprobarNotificacionInicial() async {
    final message = await _messaging.getInitialMessage();

    if (message != null) {
      debugPrint(
        'App abierta desde una notificación: ${message.messageId}',
      );
    }
  }

  Future<void> mostrarToken() async {
    final token = await _messaging.getToken();
    debugPrint('Token FCM: $token');
  }


}