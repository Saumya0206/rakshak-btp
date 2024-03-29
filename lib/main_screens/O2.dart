// ignore_for_file: unused_import, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rakshak/main_screens/PopupResult.dart';
import 'package:rakshak/main_screens/sensor/ReadSensorData.dart';
import 'dart:async';
import 'dart:convert';

// database related
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // for loading screen

// firestore collection
CollectionReference satReading =
    FirebaseFirestore.instance.collection('saturation');

late User _user;
bool DEBUG_MODE = false;

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
  bool collectingData = false;

  late AnimationController _animationController;

  late Timer _timer;

  int progress = 0;
  void _onRead() {
    progress++;
  }

  // store the data for upload
  final List<int> spo2Readouts = List.filled(DEBUG_MODE ? 1000 : 30 + 2, 0);
  final List<double> tempReadouts = List.filled(DEBUG_MODE ? 1000 : 30 + 2, 0);
  final List<int> pulseReadouts = List.filled(DEBUG_MODE ? 1000 : 30 + 2, 0);
  late int spo2Avg = 0;
  late int pulseAvg = 0;
  late double tempAvg = 0;
  int counter = 0;
  void _onDataReceive(String spo2, String temp, String pulse) {
    if (counter < 1) {
      spo2Readouts[counter] = int.parse(spo2);
      spo2Avg += int.parse(spo2);
      pulseReadouts[counter] = int.parse(pulse);
      pulseAvg += int.parse(pulse);
      tempReadouts[counter] = double.parse(temp);
      tempAvg += double.parse(temp);
      counter++;
    } else {
      spo2Avg = (spo2Avg / 1).floor();
      pulseAvg = (pulseAvg / 1).floor();
      tempAvg = (tempAvg / 1);
      connection!.close();
      collectingData = false;
      displayDialog(context);
    }
  }

  // function to add a new reading
  Future<void> addReading(name, number, spo2Avg, tempAvg, pulseAvg) {
    EasyLoading.show(status: 'Uploading...');
    return satReading.add({
      'name': name,
      'number': number,
      'timestamp': Timestamp.now(),
      'spo2': spo2Avg,
      'temp': tempAvg,
      'pulse': pulseAvg
    }).then((value) {
      EasyLoading.showSuccess('Great Success!');
      Navigator.pop(context);
      EasyLoading.dismiss();
    }).catchError((error) {
      EasyLoading.showError('Failed with Error');
      Navigator.pop(context);
      EasyLoading.dismiss();
      Navigator.pop(context);
    });
  }

  // voidCallback
  void _uploadData() {
    addReading("Shivam Kumar", "9161110768", spo2Avg, tempAvg, pulseAvg);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      duration: const Duration(seconds: 60),
    );

    _animationController.addListener(() => setState(() {}));
    TickerFuture tickerFuture = _animationController.repeat();
    tickerFuture.timeout(const Duration(seconds: 60), onTimeout: () {
      _animationController.forward(from: 0);
      _animationController.stop(canceled: true);
    });

    BluetoothConnection.toAddress(widget.device.address).then((_connection) {
      print('Positive. Connected to the device');
      connection = _connection;
      // collectingData = true;
      readSensorData = ReadSensorData(_connection, _onRead, _onDataReceive);
      readSensorData.startListening();
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  void _sendMessage(String text) async {
    text = text.trim();

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
    // display popup
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return MyPopup(
            spo2Avg,
            tempAvg,
            pulseAvg,
            _uploadData,
          );
        });
    // Navigator.pop(context);
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearProgressIndicator(
                            backgroundColor:
                                const Color.fromARGB(255, 170, 147, 216),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 45, 15, 106),
                            ),
                            value: null,
                            // value: !isConnected
                            //     ? 0.0
                            //     : double.parse(
                            //         (progress * 1.00 / 30).toStringAsFixed(1)),
                            semanticsLabel: 'Linear progress indicator',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  collectingData ? Colors.grey : Colors.green)),
                          onPressed: collectingData
                              ? () {
                                  collectingData = true;
                                }
                              : () {
                                  // start collecting data
                                  _sendMessage("S");
                                },
                          child: const Text(
                            'Start',
                            style: TextStyle(color: Colors.white),
                          ))
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
