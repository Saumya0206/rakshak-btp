import 'dart:ffi';
import 'package:flutter/material.dart';

class MyPopup extends StatelessWidget {
  String title = "Thank You!";
  String message1 = "Your average O2 saturation is: ";
  String message2 = "Your average temperature is: ";
  String message3 = "Your average pulse reading is: ";
  late int _spo2, _pulse;
  late double _temp;
  late VoidCallback _uploadData;

  MyPopup(int spo2Avg, double tempAvg, int pulseAvg, VoidCallback uploadData) {
    _spo2 = spo2Avg;
    _temp = tempAvg;
    _pulse = pulseAvg;
    _uploadData = uploadData;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      // content: Text(
      //   this.message1 + _spo2.toString(),
      //   style: Theme.of(context).textTheme.bodyText1,
      // ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // //position
        mainAxisSize: MainAxisSize.min,
        // wrap content in flutter
        children: <Widget>[
          Text(
            // this.message1 + _spo2.toString(),
            this.message1 + "99",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            this.message2 + "33.4",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            this.message3 + "100",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          // Text("Password : " + etPassword.text)
        ],
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
