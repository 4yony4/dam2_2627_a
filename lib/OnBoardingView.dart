import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Onboardingview extends StatefulWidget {
  const Onboardingview({ super.key });

  @override
  State<Onboardingview> createState() => _Onboardingview();
}

class _Onboardingview extends State<Onboardingview> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int _iProgress=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarRecursos();

  }

  void cargarRecursos() async{
    await recursos1();
    setState(() {
      _iProgress=20;
    });
    await recursos2();
    setState(() {
      _iProgress=80;
    });
    await recursos3();
    setState(() {
      _iProgress=100;
    });



    if(FirebaseAuth.instance.currentUser==null){
      Navigator.popAndPushNamed(context, "/LoginView");
    }
    else{
      String uid=FirebaseAuth.instance.currentUser!.uid;
      print("EL UID DEL URUSARIO LOGEADO ES: "+uid);
      final docRef = db.collection("Perfiles").doc(uid);
      docRef.get().then(
            (DocumentSnapshot doc) {
          if(doc.data()==null){//NO TIENE PERFIL EN LA BASE DE DATOS
            Navigator.popAndPushNamed(context, "/Profileview");
          }
          else{
            //SI TIENE PERFIL EN LA BASE DATOS
            final data = doc.data() as Map<String, dynamic>;
            print("EL UID DEL URUSARIO LOGEADO ES: "+data["altura"].toString());

            Navigator.popAndPushNamed(context, "/HomeView");
          }


          // ...
        },
        onError: (e) => print(e.toString()),
      );

    }

  }

  Future<void> recursos1() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> recursos2() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> recursos3() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Image.network('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
            /*Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: CircularProgressIndicator(),
            ),*/
            Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: LinearProgressIndicator(value: _iProgress/100,)
            ),
            Text("$_iProgress%")
          ],
        ),
      ),
    );
  }
}