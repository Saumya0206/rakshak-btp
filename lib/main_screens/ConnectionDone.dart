import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectionDone extends StatelessWidget {
  static String id = "/connected";

  late BluetoothDevice device;

  ConnectionDone(BluetoothDevice d) {
    device = d;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("here"),
    );
  }

  // @override
  // _ConnectionDoneState createState() => _ConnectionDoneState();
}

// class _ConnectionDoneState extends State<ConnectionDone>{
//   BluetoothDevice device;



//   @override

// }