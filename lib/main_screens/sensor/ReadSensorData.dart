import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rakshak/main_screens/sensor/Max30102.dart';

import 'package:characters/characters.dart';

class ReadSensorData {
  final bool DEBUG_MODE = false;
  final int READING_BATCH_SIZE = 30;
  final int AVG_WINDOW_SIZE = 4; // what is this?
  int secondsCount = 0; // helps in ignoring first 3 seconds of reading
  bool uploadWhenGenerated = false;
  late BluetoothConnection connection;
  bool isConnecting = false;
  bool isDisconnecting = false;
  String partialFrame = "";

  ReadSensorData(BluetoothConnection d) {
    connection = d;
  }

  void startListening() {
    print("well");
    connection.input!.listen(_onDataReceived).onDone(() {
      if (isDisconnecting) {
        print('Disconnecting locally!');
      } else {
        print('Disconnected remotely!');
      }
    });
  }

  // is the device still connected
  bool get isConnected => (connection.isConnected ? true : false);

  void _onDataReceived(Uint8List data) {
    // int timer = 5;
    // bool setupSuccessful = false;
    // List<ByteData> buffer = List.filled(1024, );
    int numBytes = ascii.decode(data).length;
    // print(secondsCount);
    // print(READING_BATCH_SIZE + 5);
    // if (secondsCount < READING_BATCH_SIZE + 5) {
    if (secondsCount > 2) {
      List<String> chars = ascii.decode(data).split('');

      // filtered undefined ascii characters
      for (int i = 0; i < numBytes; i++) {
        chars[i] = chars[i].codeUnitAt(0) >= 32 && chars[i].codeUnitAt(0) <= 126
            ? chars[i]
            : ' ';
      }

      // generate new string without any whitespace
      String newData = chars.join().replaceAll(' ', '');

      List<Max30102> currReading = parseData(newData);
      // print("Current Reading:  ${currReading.toString()}");
    }
    sleep(const Duration(milliseconds: 1000));
    secondsCount++;
    // }
    // print('Data Incoming: ${ascii.decode(data)}');
  }

  List<Max30102> parseData(String data) {
    List<Max30102> allFrames = List.filled(
        DEBUG_MODE ? 1000 : READING_BATCH_SIZE + 2, Max30102(0, 0, 0),
        growable: true);

    int framesStartIndex = data.indexOf('^');
    int framesEndIndex = data.lastIndexOf("\$");

    // DEBUGGING
    // print("==================");
    // print(data);
    // print(framesStartIndex);
    // print(framesEndIndex);
    // print("==================");

    if (framesStartIndex == -1) {
      // if both ^ and $ are not in the string, add it to partial frame
      if (framesEndIndex == -1) {
        partialFrame += data;
      }
      // if start is not present, but end is present, add it to previous partialframe and process
      // also set partialFrame to everything after $
      else {
        String frame = partialFrame + data.substring(0, framesEndIndex + 1);
        partialFrame = data.substring(framesEndIndex + 1);
        return parseFrames(frame, allFrames);
      }
    }
    // if ^ is present somewhere in the middle, check partialFrame
    // if it is non-empty, combine partialFrame with everything before ^ and process it
    // set partialFrame to everything after that
    else if (framesStartIndex != 0) {
      if (!identical("", partialFrame)) {
        String frame = partialFrame + data.substring(0, framesStartIndex);
        partialFrame = data.substring(framesStartIndex);
        return parseFrames(frame, allFrames);
      }
    }
    // if string starts with ^, clear partialFrame
    partialFrame = "";
    if (framesEndIndex == -1) {
      partialFrame = data;
      return parseFrames(data, allFrames);
    } else if (framesEndIndex != data.length - 1) {
      partialFrame = data.substring(framesEndIndex + 1);
      return parseFrames(data.substring(0, framesEndIndex + 1), allFrames);
    }
    return parseFrames(data, allFrames);

    // if (framesStartIndex != 0) {
    //   if (!identical("", partialFrame)) {
    //     String frame = partialFrame + data.substring(0, framesStartIndex);
    //     parseFrames(frame, allFrames);
    //   }
    // } else {
    //   partialFrame = "";
    // }
    // if (framesEndIndex != data.length - 1) {
    //   partialFrame = data.substring(framesEndIndex + 1);
    // }
    // return parseFrames(data, allFrames);
  }

  List<Max30102> parseFrames(String data, List<Max30102> allFrames) {
    print("im here, string is $data");
    RegExp pattern = RegExp("\\^(\\d+)\\|(\\d+)\\|(\\d+)\\\$");
    for (Match m in pattern.allMatches(data)) {
      int temp = int.parse(m.group(1).toString());
      int pulse = int.parse(m.group(2).toString());
      int spo2 = int.parse(m.group(3).toString());
      // ignore null values
      // if (temp == 0 || pulse == 0 || spo2 == 0) {
      // continue;
      // }
      print("$pulse $spo2 $temp");
      allFrames.add(Max30102(spo2, pulse, temp / 10.0));
    }

    return allFrames;
  }
}
