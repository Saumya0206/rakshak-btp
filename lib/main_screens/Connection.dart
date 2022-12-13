import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  static String id = "/connect";

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text('R A K S H A K', style: TextStyle(fontSize: 40)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 93, 23, 105),
        foregroundColor: Colors.white,
        elevation: 1.0,
      ),
    );
  }
}
