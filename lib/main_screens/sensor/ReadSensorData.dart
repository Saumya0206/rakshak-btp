import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rakshak/main_screens/sensor/Max30102.dart';

class ReadSensorData {
  final bool DEBUG_MODE = false;
  final int BATCH_SIZE = 30;
  bool uploadWhenGenerated = false;
  late BluetoothConnection connection;
  bool isConnecting = false;
  bool isDisconnecting = false;
  String partialFrame = "";

  ReadSensorData(BluetoothConnection d) {
    connection = d;
  }

  // is the device still connected
  bool get isConnected => (connection.isConnected ? true : false);

  void _onDataReceived(String data) {}

  List<Max30102> parseData(String data) {
    List<Max30102> allFrames =
        List.filled(DEBUG_MODE ? 1000 : BATCH_SIZE + 2, Max30102(0, 0, 0));

    int framesStartIndex = data.indexOf('^');
    int framesEndIndex = data.lastIndexOf("\$");
    if (framesStartIndex != 0) {
      if (!identical("", partialFrame)) {
        String frame = partialFrame + data.substring(0, framesStartIndex);
        parseFrames(frame, allFrames);
      }
    } else {
      partialFrame = "";
    }
    if (framesEndIndex != data.length - 1) {
      partialFrame = data.substring(framesEndIndex + 1);
    }

    return parseFrames(data, allFrames);
  }

  List<Max30102> parseFrames(String data, List<Max30102> allFrames) {
    RegExp pattern = RegExp("\\^(\\d+)\\|(\\d+)\\|(\\d+)\\\$");
    for (Match m in pattern.allMatches(data)) {
      int temp = int.parse(m.group(1).toString());
      int pulse = int.parse(m.group(2).toString());
      int spo2 = int.parse(m.group(3).toString());
      if (temp == 0 || pulse == 0 || spo2 == 0) {
        continue;
      }
      allFrames.add(new Max30102(spo2, pulse, temp / 10.0));
    }

    return allFrames;
  }
}
