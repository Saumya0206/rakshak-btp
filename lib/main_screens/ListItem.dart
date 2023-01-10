import 'package:flutter/material.dart';

// show readings store in firestore

class ListItem extends StatelessWidget {
  String? _spo2;
  String? _temp;
  String? _pulse;
  String? _timestamp;

  ListItem(String spo2, String temp, String pulse, String timestamp) {
    _spo2 = spo2;
    _pulse = pulse;
    _temp = temp;
    _timestamp = timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("spo2: $_spo2\n"),
        Text("temp: $_temp\n"),
        Text("pulse: $_pulse\n"),
        Text("timestamp: $_timestamp\n"),
      ],
    );
  }
}
