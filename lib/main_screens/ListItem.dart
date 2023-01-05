import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  String? _spo2;
  String? _temp;
  String? _pulse;

  ListItem(String spo2, String temp, String pulse) {
    _spo2 = spo2;
    _pulse = pulse;
    _temp = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("spo2: $_spo2"),
        Text("temp: $_temp"),
        Text("pulse: $_pulse"),
      ],
    );
  }
}
