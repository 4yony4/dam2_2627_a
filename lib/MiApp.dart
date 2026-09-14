
import 'package:flutter/material.dart';

class Miapp extends StatelessWidget {
  double dbNumber=0.0;
  late BuildContext globalContext;

  void funClickLogin(){
    print("---->>>>>>>> LOGIN CLICKED");

  }

  void funClickRegistro(){
    print("---->>>>>>>> REGISTRO CLICKED");
  }

  @override
  Widget build(BuildContext context) {
    globalContext=context;
    TextStyle tsEstiloTexto=new TextStyle(fontSize: 30,backgroundColor:Colors.red);

    return new MaterialApp(
      title: "MI APP 1",
      home: new Scaffold(
        appBar: new AppBar(title:new Text("MI APP 1"),),
        body: Column(
          mainAxisAlignment:MainAxisAlignment.start,
          children: [
            Text("LOGIN",style: tsEstiloTexto,),
            TextField(decoration: InputDecoration(hintText: "Usuario"),),
            TextField(decoration: InputDecoration(hintText: "Contraseña"),),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: funClickLogin, child: Text("Login")),
                TextButton(onPressed: funClickRegistro, child: Text("Registrarse"))
              ],
            )
          ],
        ),
      ),
      routes: {
        "LoginView" =>
      },
      initialRoute: "LoginView",
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Scaffold(
        body: CarouselView(
          scrollDirection: Axis.vertical,
          itemExtent: double.infinity,
          children: List<Widget>.generate(10, (int index) {
            return Center(child: Text('Item $index'));
          }),
        ),
      ),
    );

  }
*/
  
}
