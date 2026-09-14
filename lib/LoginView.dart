import 'package:flutter/material.dart';

class Loginview extends StatelessWidget{
  late BuildContext miContext;
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void funClickLogin(){
    String usuario=userController.text;
    String pass=passwordController.text;
    print("---->>>>>>>> LOGIN PRESIONADO "+usuario+"   "+pass);
    if(usuario=="Yony" && pass=="123456"){
      Navigator.popAndPushNamed(miContext, "/HomeView");
    }
    //Navigator.pushNamed(miContext, "/HomeView");
    //Navigator.popAndPushNamed(miContext, "/HomeView");

  }

  void funClickRegistro(){
    print("---->>>>>>>> REGISTRO PRESIONADO");
  }

  @override
  Widget build(BuildContext context) {
    miContext=context;
    TextStyle tsEstiloTexto=new TextStyle(fontSize: 30,backgroundColor:Colors.red);

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title:new Text("MI APP DAM2627"),),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          Text("LOGIN",style: tsEstiloTexto,),
          TextField(controller: userController,decoration: InputDecoration(hintText: "Usuario"),),
          TextField(controller:passwordController,decoration: InputDecoration(hintText: "Contraseña"),),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: funClickLogin, child: Text("Login")),
              TextButton(onPressed: funClickRegistro, child: Text("Registrarse"))
            ],
          )
        ],
      ),
    );
  }

}