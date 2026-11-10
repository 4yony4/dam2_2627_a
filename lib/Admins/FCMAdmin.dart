
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Mensaje recibido en segundo plano: ${message.messageId}');
}

class Fcmadmin {

  Function(RemoteMessage message)? onPushReceived;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> iniciar() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw StateError('Primero inicia sesión');
    }

    final token = await user.getIdToken(true);

    if (token != null) {
      await Clipboard.setData(ClipboardData(text: token));
      print('Token completo copiado al portapapeles');
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler,);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_mostrarMensajeEnPrimerPlano);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notificación abierta: ${message.messageId}');
      onPushReceived?.call(message);
    });
  }

  void _mostrarMensajeEnPrimerPlano(RemoteMessage message) {
    final titulo = message.notification?.title ?? 'Nueva notificación';
    final texto = message.notification?.body ?? '';

    final contenido = texto.isEmpty ? titulo : '$titulo\n$texto';

    print("------->>>>>>!!!!!!!! "+contenido);

    onPushReceived?.call(message);

  }


  Future<void> comprobarNotificacionInicial() async {
    final message = await _messaging.getInitialMessage();

    if (message != null) {
      debugPrint(
        'App abierta desde una notificación: ${message.messageId}',
      );

      onPushReceived?.call(message);
    }
  }

  Future<String?> mostrarToken() async {
    final token = await _messaging.getToken();
    debugPrint('Token FCM: $token');
    return token;
  }

  Future<Map<String, dynamic>> enviarPushEnRadio({
    required double lat,
    required double lon,
    required double radioKm,
    required String titulo,
    required String mensaje,
    bool excluirEmisor = true,
  }) async {
    final resultado = await FirebaseFunctions.instance
        .httpsCallable(
      'enviarPushEnRadio',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 120),
      ),
    )
        .call({
      'lat': lat,
      'lon': lon,
      'radioKm': radioKm,
      'titulo': titulo,
      'mensaje': mensaje,
      'excluirEmisor': excluirEmisor,
    });

    return Map<String, dynamic>.from(resultado.data as Map);
  }


}