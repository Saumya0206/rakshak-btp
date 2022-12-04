import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/main_screens/PopupResult.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late int result;

  void displayDialog(BuildContext context) {
    Random random = new Random();
    result = random.nextInt(100);

    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return MyPopup(result);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDialog(context);
        },
        child: Text('click'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}
