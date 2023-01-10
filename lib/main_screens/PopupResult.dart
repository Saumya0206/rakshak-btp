import 'package:flutter/material.dart';

// Popup that shows results

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
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // //position
        mainAxisSize: MainAxisSize.min,
        // wrap content in flutter
        children: <Widget>[
          Text(
            this.message1 + _spo2.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            this.message2 + _temp.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            this.message3 + _pulse.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
            _uploadData();
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
