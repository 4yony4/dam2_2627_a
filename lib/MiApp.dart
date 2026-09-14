
import 'package:dam2_2627_a/LoginView.dart';
import 'package:flutter/material.dart';

class Miapp extends StatelessWidget {
  double dbNumber=0.0;

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: "MI APP 1",
      routes: {
        "LoginView" : (context) =>  Loginview(),
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
