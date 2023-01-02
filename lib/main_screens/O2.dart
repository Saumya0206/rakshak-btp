// ignore_for_file: unused_import, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rakshak/main_screens/PopupResult.dart';
import 'package:rakshak/main_screens/sensor/ReadSensorData.dart';
import 'package:rakshak/main_screens/sensor/uploadTask.dart';

import 'dart:async';
import 'dart:convert';

// database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // for loading screen

CollectionReference satReading =
    FirebaseFirestore.instance.collection('saturation');

late User _user;

// function to add a new reading
Future<void> addStudent(name, number, value, context) {
  EasyLoading.show(status: 'loading...');
  return satReading.add({
    'name': name,
    'number': number,
    'timestamp': Timestamp.now(),
    'value': value
  }).then((value) {
    EasyLoading.showSuccess('Great Success!');
    Navigator.pop(context);
    EasyLoading.dismiss();
  }).catchError((error) {
    EasyLoading.showError('Failed with Error');
    Navigator.pop(context);
    EasyLoading.dismiss();
  });
}

// ignore: must_be_immutable
class O2 extends StatefulWidget {
  final BluetoothDevice device;
  static String id = '/O2';

  const O2({Key? key, required this.device}) : super(key: key);

  @override
  _O2State createState() => _O2State();
}

class _O2State extends State<O2> with TickerProviderStateMixin {
  late AnimationController controller;
  final bool _showSpinner = false;
  late int result;

  BluetoothConnection? connection;
  late ReadSensorData readSensorData;

  bool isConnecting = true;
  bool isDisconnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);

  late AnimationController _animationController;

  late Timer _timer;

  int progress = 0;
  void _onRead() {
    progress++;
    print("Here is progress: ${progress / 30}. Connection state: $isConnected");
  }

  @override
  void initState() {
    super.initState();

    // easy loading timer
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer.cancel();
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _animationController.addListener(() => setState(() {}));
    TickerFuture tickerFuture = _animationController.repeat();
    tickerFuture.timeout(const Duration(seconds: 3 * 10), onTimeout: () {
      _animationController.forward(from: 0);
      _animationController.stop(canceled: true);
    });

    BluetoothConnection.toAddress(widget.device.address).then((_connection) {
      print('Positive. Connected to the device');
      connection = _connection;
      readSensorData = ReadSensorData(_connection, _onRead);
      readSensorData.startListening();
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  void _sendMessage(String text) async {
    text = text.trim();
    print(text);

    if (text.isNotEmpty) {
      try {
        connection?.output.add(Uint8List.fromList(utf8.encode(text)));
        // connection!.output.add(Uint8List.fromList(utf8.encode(text)));
        await connection!.output.allSent;
      } catch (e) {
        print(e);
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  // @override
  // void initState() {
  //   controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 30),
  //   )..addListener(() {
  //       setState(() {});
  //     });
  //   controller.repeat(reverse: false);
  //   super.initState();
  // }

  @override
  void dispose() {
    controller.dispose();

    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  void displayDialog(BuildContext context) {
    Random random = Random();
    result = random.nextInt(100);

    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return MyPopup(result);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        color: Colors.blueAccent,
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.topRight,
              // child: Image.asset('assets/images/background.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 90.0, bottom: 60.0, left: 40.0, right: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Material(
                        child: InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset('assets/images/o2.png',
                                width: 200.0, height: 200.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 10),
                      Text(
                        'To measure the Oxygen level in the body do the following',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                  Column(
                    children: [
                      Material(
                        child: InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset('assets/images/touchSensor.png',
                                width: 360.0, height: 145.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 10),
                      Text(
                        'Please put you finger on the sensor for minimum 30 seconds',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 150),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Text(
                        'O2:',
                        style: TextStyle(fontSize: 20),
                      ),
                      LinearProgressIndicator(
                        backgroundColor:
                            const Color.fromARGB(255, 170, 147, 216),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 45, 15, 106),
                        ),
                        value: !isConnected
                            ? 0.0
                            : double.parse(
                                (progress * 1.00 / 30).toStringAsFixed(1)),
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: () {
                          displayDialog(context);
                          // _sendMessage("Your O2 saturation is: $result");
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
