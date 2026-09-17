
import 'package:dam2_2627_a/HomeView.dart';
import 'package:dam2_2627_a/LoginView.dart';
import 'package:dam2_2627_a/RegisterView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'OnBoardingView.dart';
import 'ProfileView.dart';

class Miapp extends StatelessWidget {
  double dbNumber=0.0;

  @override
  Widget build(BuildContext context) {

    String rutaInicial="/LoginView";
    if(FirebaseAuth.instance.currentUser!=null){
      rutaInicial="/HomeView";
    }

    return new MaterialApp(
      title: "MI APP 1",
      routes: {
        "/LoginView" : (context) =>  Loginview(),
        "/HomeView" : (context) =>  Homeview(),
        "/RegisterView" : (context) =>  Registerview(),
        "/Onboardingview":(context) => Onboardingview(),
        "/Profileview":(context) => Profileview(),

      },
      initialRoute: "/Onboardingview",
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
