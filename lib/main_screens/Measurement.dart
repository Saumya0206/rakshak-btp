import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';
import 'package:rakshak/main_screens/PopupResult.dart';
import 'package:flutter/services.dart';
import 'package:rakshak/main_screens/ResultPage.dart';
import 'package:rakshak/main_screens/connection_serial/ConnectionSerial.dart';
import 'package:feature_discovery/feature_discovery.dart';

// bottom navigation
import 'package:rakshak/main_screens/HomeMain.dart';

// Telestethoscope
import 'package:rakshak/main_screens/telestethoscope/RecordPage.dart';

late User loggedInUser;
int _index = 0;

// ignore: must_be_immutable
class Measurement extends StatefulWidget {
  static String id = '/Measurement';

  @override
  _MeasurementState createState() => _MeasurementState();
}

class _MeasurementState extends State<Measurement> {
  bool _showSpinner = false;
  late int result;

  // Get current logged in user
  final _auth = FirebaseAuth.instance;
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  // initialize current logged in user
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = HomeMain();

    // switch between different views from the bottom navigation bar
    switch (_index) {
      case 0:
        break;
      case 1:
        child = ResultPage();
        break;
      default:
        child = HomeMain();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('R A K S H A K', style: TextStyle(fontSize: 40)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 156, 92, 167),
        foregroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: SizedBox.expand(child: child),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // Fixed
            currentIndex: _index,
            onTap: (int index) {
              if (index != 0) {
                setState(() => _index = index);
              } else {
                setState(() => _index = index);

                // start the tutorial
                FeatureDiscovery.discoverFeatures(
                  context,
                  const <String>{
                    'reading',
                    'manual',
                    'record',
                    'collect',
                    'home',
                  },
                );
              }
            },
            backgroundColor: const Color.fromARGB(255, 114, 38, 128),
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: const Color.fromARGB(255, 185, 131, 195),
            items: const [
              BottomNavigationBarItem(
                // icon: Icon(Icons.library_books_rounded),
                icon: DescribedFeatureOverlay(
                  featureId: 'manual',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 208, 154, 218),
                  contentLocation: ContentLocation.trivial,
                  title: Text(
                    'Manual',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  overflowMode: OverflowMode.extendBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text('Click here to take a tour'),
                  tapTarget: Icon(Icons.library_books_rounded),
                  child: Icon(Icons.library_books_rounded),
                ),
                label: 'Manual',
              ),
              BottomNavigationBarItem(
                icon: DescribedFeatureOverlay(
                  featureId: 'reading',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 208, 154, 218),
                  contentLocation: ContentLocation.trivial,
                  title: Text(
                    'Reading',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  overflowMode: OverflowMode.extendBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text('Click here to see the previous readings'),
                  tapTarget: Icon(Icons.bookmark_add_rounded),
                  child: Icon(Icons.bookmark_add_rounded),
                ),
                label: 'Reading',
              ),
              BottomNavigationBarItem(
                // icon: Icon(Icons.home),
                icon: DescribedFeatureOverlay(
                  featureId: 'home',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 208, 154, 218),
                  contentLocation: ContentLocation.trivial,
                  title: Text(
                    'Home Page',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  overflowMode: OverflowMode.extendBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text('Click here to return to home page'),
                  tapTarget: Icon(Icons.home),
                  child: Icon(Icons.home),
                ),
                label: 'Home',
              ),
              // ],
            ]),
      ),
    );
  }
}
