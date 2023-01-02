import 'dart:ffi';
import 'package:flutter/material.dart';

class MyPopup extends StatelessWidget {
  String title = "Thank You!";
  String message = "Your average O2 saturation is: ";
  late int _result;
  late VoidCallback _uploadData;

  MyPopup(int result, VoidCallback uploadData) {
    _result = result;
    _uploadData = uploadData;
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
          onPressed: () {
            Navigator.pop(context, 'OK');
            _uploadData();
          },
          child: Text('OK'),
        )
      ],
    );
  }
}
