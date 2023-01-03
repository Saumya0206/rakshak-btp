import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rakshak/main_screens/sensor/Max30102.dart';

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

  int readingsCount = 0; // number of valid readings
  // list of all valid readings
  late List<Max30102> allReadingsList =
      List.filled(READING_BATCH_SIZE + 5, Max30102(0, 0, 0), growable: true);

  late VoidCallback _onRead;
  late Function _updateData;

  ReadSensorData(
      BluetoothConnection d, VoidCallback func, Function updateData) {
    connection = d;
    _onRead = func;
    _updateData = updateData;
  }

  void startListening() {
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
    int numBytes = ascii.decode(data).length;
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

      List<Max30102> currReadings = parseData(newData);
      // print("Current Reading:  ${currReading.toString()}");

      int validReadingsIndex = clearInvalidReadings(currReadings, true);
      print("===starting loop===");
      for (int i = 0; i < currReadings.length; i++) {
        print("$i: ${currReadings[i]}");
      }
      print("===ending loop====");
      // print("$secondsCount $validReadingsIndex");
      Max30102 avgReading = Max30102(0, 0, 0);

      if (validReadingsIndex != -1) {
        allReadingsList.addAll(
            currReadings.sublist(validReadingsIndex, currReadings.length));
        readingsCount += currReadings.length - validReadingsIndex;

        for (int i = readingsCount - 1;
            i >= max(readingsCount - AVG_WINDOW_SIZE, 0);
            --i) {
          // print("this runs");
          // print("adding: ${allReadingsList[i]}");
          avgReading.add(allReadingsList[i]);
          // print("avg: $avgReading");
        }
        // print("avgReading:spo2 value: ${avgReading.spo2}");
        if (readingsCount > 0) {
          avgReading.divBy(min(readingsCount, AVG_WINDOW_SIZE));
        }
      }

      if (secondsCount >= 5 && validReadingsIndex != -1) {
        _onRead();
        _updateData(
          avgReading.spo2.toString(),
          avgReading.temp.toString(),
          avgReading.pulse.toString(),
        );
      }
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
      if (temp == 0 || pulse == 0 || spo2 == 0) {
        // print("found null value");
        continue;
      }

      print("$pulse $spo2 $temp");
      // print("New: ${Max30102(spo2, pulse, temp / 10.0)}");
      allFrames.add(Max30102(spo2, pulse, temp / 10.0));
    }

    return allFrames;
  }

  int clearInvalidReadings(List<Max30102> readingsArr, bool strict) {
    int validReadingsIndex = -1;
    int lastValidPulse = 0;
    int lastValidSpo2 = 0;
    double lastValidTemper = 0;

    for (int i = 0; i < readingsArr.length; ++i) {
      if (strict
          ? readingsArr[i].getPulse() > 30 && readingsArr[i].getPulse() < 220
          : readingsArr[i].getPulse() > 0) {
        lastValidPulse = readingsArr[i].getPulse();
        validReadingsIndex = validReadingsIndex != -1 ? validReadingsIndex : i;
      } else if (lastValidPulse > 0) {
        readingsArr[i].setPulse(lastValidPulse);
      }

      if (strict
          ? readingsArr[i].getSpo2() > 60 && readingsArr[i].getSpo2() < 100
          : readingsArr[i].getSpo2() > 0) {
        lastValidSpo2 = readingsArr[i].getSpo2();
        validReadingsIndex = validReadingsIndex != -1 ? validReadingsIndex : i;
      } else if (lastValidSpo2 > 0) {
        readingsArr[i].setSpo2(lastValidSpo2);
      }

      if (strict
          ? readingsArr[i].getTemp() > 20 && readingsArr[i].getTemp() < 42
          : readingsArr[i].getTemp() > 0) {
        lastValidTemper = readingsArr[i].getTemp();
        validReadingsIndex = validReadingsIndex != -1 ? validReadingsIndex : i;
      } else if (lastValidTemper > 0) {
        readingsArr[i].setTemp(lastValidTemper);
      }
    }
    return validReadingsIndex;
  }
}
