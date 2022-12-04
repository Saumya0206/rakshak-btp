import 'dart:ffi';
import 'package:flutter/material.dart';

class MyPopup extends StatelessWidget {
  String title = "Thank You!";
  String message = "Your average O2 saturation is: ";
  late int _result;

  MyPopup(int result) {
    _result = result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      content: Text(
        this.message + _result.toString(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text('OK'),
        )
      ],
    );
  }
}
