import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Deviceadmin {

  BuildContext context;

  Deviceadmin(this.context);

  /// Altura total de la pantalla en píxeles lógicos, incluidas las zonas
  /// ocupadas por las barras del sistema.
  double getDeviceHeight() {
    return MediaQuery.sizeOf(context).height;
  }

  /// Anchura total de la pantalla en píxeles lógicos.
  double getDeviceWidth() {
    return MediaQuery.sizeOf(context).width;
  }

  TargetPlatform getPlatform() {
    return defaultTargetPlatform;
  }

  bool isWeb(){
    return kIsWeb;
  }

  bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  bool isiOS() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool isMac() {
    return defaultTargetPlatform == TargetPlatform.macOS;
  }

  bool isWindows() {
    return defaultTargetPlatform == TargetPlatform.windows;
  }

  bool isLinux() {
    return defaultTargetPlatform == TargetPlatform.linux;
  }
}
