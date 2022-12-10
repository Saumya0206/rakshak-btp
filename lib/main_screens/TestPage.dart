// ignore_for_file: avoid_print, file_names

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/main_screens/PopupResult.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TestPage extends StatefulWidget {
  static String id = '/TestPage';

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // path to the 'saturation' collection in firestore
  CollectionReference saturation =
      FirebaseFirestore.instance.collection('saturation');

  late int result;

  Future<void> addReading() {
    return saturation
        .add({
          'name': 'Shivam Kumar',
          'phone': '9161110768',
          'value': result,
          'timestamp': DateTime.now()
        })
        .then((value) => print('Reading added'))
        .catchError((error) => print("Could not add student. Error: $error"));
  }

  void displayDialog(BuildContext context) {
    Random random = new Random();
    result = random.nextInt(100);

    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return MyPopup(result);
        });
    addReading();
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
