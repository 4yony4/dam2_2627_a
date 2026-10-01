// =====================================================================
// main.dart — PUNTO DE ENTRADA DE LA APP
// ---------------------------------------------------------------------
// Es el primer código que se ejecuta: Dart siempre empieza por main().
// Su trabajo es muy corto:
//   1. Preparar el motor de Flutter (WidgetsFlutterBinding).
//   2. Conectar la app con nuestro proyecto de Firebase (Firebase.initializeApp).
//   3. Lanzar el widget raíz Miapp (MiApp.dart) con runApp().
// Las rutas (pantallas), el tema y la primera pantalla se configuran en
// MiApp.dart; la primera pantalla real es OnBoardingView.
// =====================================================================
import 'package:dam2_2627_a/MiApp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

/// Función principal: lo primero que se ejecuta al abrir la app.
///
/// Es `async` porque tiene que ESPERAR (`await`) a que Firebase termine de
/// inicializarse antes de mostrar ninguna pantalla: si una vista usara Auth
/// o Firestore sin Firebase inicializado, la app fallaría.
void main() async{

  // Obligatorio cuando hay código asíncrono (como Firebase) ANTES de runApp():
  // asegura que el "puente" entre Dart y la plataforma nativa (Android/Web)
  // ya está creado.
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase con la configuración de la plataforma actual (Android
  // o Web), que está en firebase_options.dart (generado por `flutterfire configure`).
  // Devuelve un Future: con `await` esperamos a que termine.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp() recibe el widget raíz y lo dibuja ocupando toda la pantalla.
  runApp(Miapp());
}

// NOTA: MyApp, MyHomePage y _MyHomePageState son el ejemplo del contador que
// genera `flutter create`. NO se usan en ninguna parte (runApp lanza Miapp,
// no MyApp). Se han dejado como referencia: sus comentarios en inglés
// explican muy bien setState y build. ¿Qué pasaría si las borrásemos?
//
/// Widget raíz de la plantilla de ejemplo de Flutter (NO se usa en esta app).
/// Es un StatelessWidget porque no guarda ningún dato que cambie.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// Página de ejemplo con un contador (plantilla; NO se usa en esta app).
/// Es un StatefulWidget porque el número del contador cambia y la pantalla
/// tiene que redibujarse cuando eso ocurre.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  /// Título de la AppBar. Es `final` porque los widgets son inmutables.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State del contador: aquí viven los datos que cambian (_counter) y el
/// método build() que pinta la pantalla.
class _MyHomePageState extends State<MyHomePage> {
  /// Veces que se ha pulsado el botón. El `_` inicial lo hace privado al archivo.
  int _counter = 0;

  /// Suma 1 al contador dentro de setState() para que se vea en pantalla.
  void _incrementCounter() {
    setState(() {
      // (ES) setState() avisa a Flutter de que el estado ha cambiado: vuelve a
      // ejecutar build() y la pantalla muestra el nuevo valor. Sin setState la
      // variable cambiaría, pero la pantalla NO se actualizaría.
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  /// Dibuja la pantalla del contador. Se vuelve a ejecutar tras cada setState().
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
