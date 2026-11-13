import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';

/// Lectura de tags NFC. Cubre los dos casos:
///  1. La app estaba CERRADA y Android la abre al acercar un tag
///     (AndroidManifest + MainActivity.kt). El UID llega por el canal
///     "nfc_launch": lo pedimos con "getTagInicial".
///  2. La app ya está ABIERTA: el tag llega por "onTag" (MainActivity.onNewIntent)
///     o por la sesión de nfc_manager (onDiscovered).
class Nfcadmin {

  /// Mismo nombre que en MainActivity.kt.
  static const MethodChannel _canal = MethodChannel('nfc_launch');

  Future<void> iniciar() async {
    // El canal y la apertura por NFC solo existen en Android.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    // Tags que llegan desde Android con la app ya abierta.
    _canal.setMethodCallHandler((call) async {
      if (call.method == 'onTag') {
        print("HE LEIDO LA TAG (app abierta): ${call.arguments}");
      }
    });

    // ¿Se ha abierto la app acercando un tag?
    final String? uidInicial = await _canal.invokeMethod<String>('getTagInicial');
    if (uidInicial != null) {
      print("HE LEIDO LA TAG (app abierta por NFC): $uidInicial");
    }

    // Check the availability of NFC on the current device.
    NfcAvailability availability = await NfcManager.instance.checkAvailability();

    if (availability != NfcAvailability.enabled) {
      print('NFC may not be supported or may be temporarily disabled.');
      return;
    }

    //REGISTRA SI SE ACERCA A UN NFC Y SE ACTIVA
    // Start the session.
    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443}, // You can also specify iso18092 and iso15693.
      onDiscovered: (NfcTag tag) async {
        print("HE LEIDO LA TAG: ${_uid(tag)}");

        // Stop the session when no longer needed.
        await NfcManager.instance.stopSession();
      },
    );
  }

  /// UID del tag en hexadecimal (igual que el que imprime MainActivity.kt).
  String _uid(NfcTag tag) {
    final id = NfcTagAndroid.from(tag)?.id;
    if (id == null) return tag.toString();
    return id.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
  }
}
