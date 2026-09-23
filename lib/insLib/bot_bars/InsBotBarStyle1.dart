import 'package:flutter/material.dart';

class Insbotbarstyle1 extends StatefulWidget{
  bool blBadge1=true;
  String sBadge2="";
  int iBarIndex=0;

  Insbotbarstyle1({required this.blBadge1,required this.sBadge2,required this.iBarIndex});

  @override
  State<Insbotbarstyle1> createState() => _Insbotbarstyle1State();
}

class _Insbotbarstyle1State extends State<Insbotbarstyle1> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void BotBarItemSelected(int index){
    switch (index){
      case 0: print("HOME");
      case 1: {
        print("NOTIFICATION");
        setState(() {
          widget.blBadge1=false;
        });
      }
      case 2: {
        print("MESSAGES");
        setState(() {
          widget.sBadge2="";
        });
        Navigator.popAndPushNamed(context, "/Messagesview");
      }

    }
    setState(() {
      widget.iBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected:BotBarItemSelected,
      indicatorColor: Colors.amber,
      selectedIndex: widget.iBarIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Principal',
        ),
        NavigationDestination(
          icon: Badge(isLabelVisible:widget.blBadge1, child: Icon(Icons.notifications_sharp)),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Badge(isLabelVisible:widget.sBadge2.isNotEmpty, label: Text(widget.sBadge2), child: Icon(Icons.messenger_sharp)),
          label: 'Messages',
        ),
      ],
    );

  }
}