import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';
import 'package:flutter/material.dart';

import '../DataHolder.dart';

class Messagesview extends StatefulWidget{
  @override
  State<Messagesview> createState() => _MessagesviewState();
}

class _MessagesviewState extends State<Messagesview> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Text("MESSAGES VIEW"),
        bottomNavigationBar: Dataholder.instance.insbotbarstyle1,
    );
  }
}