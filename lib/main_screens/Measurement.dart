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

    switch (_index) {
      case 0:
        // child = FlutterLogo(colors: Colors.orange);
        onPressed:
        () {
          print("yep");
          FeatureDiscovery.discoverFeatures(
            context,
            const <String>{
              'system',
              'reading',
            },
          );
        };
        break;

      case 1:
        child = ResultPage();
        // onPressed:
        // () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ResultPage(),
        //     ),
        //   );
        // };
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
        backgroundColor: const Color.fromARGB(255, 114, 38, 128),
        foregroundColor: Colors.white,
        elevation: 1.0,
      ),
      // resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.white,
      body: SizedBox.expand(child: child),
      // bottomNavigationBar: BottomNavigationBar(
      // toolbarHeight: 70,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // Fixed
            currentIndex: _index,
            onTap: (int index) {
              setState(() => _index = index);
            },
            backgroundColor: Color.fromARGB(255, 114, 38, 128),
            selectedItemColor: Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: Color.fromARGB(255, 185, 131, 195),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_rounded),
                label: 'Manual',

                // backgroundColor: Color.fromARGB(255, 93, 23, 105),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add_rounded),
                label: 'Reading',
                // backgroundColor: Color.fromARGB(255, 93, 23, 105),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                // backgroundColor: Color.fromARGB(255, 93, 23, 105),
              ),
              // ],
              // currentIndex: _selectedIndex,
              // selectedItemColor: Color.fromARGB(255, 255, 255, 255),
              // onTap: _onItemTapped,
            ]),
        // ),
        // items: const <BottomNavigationBarItem>[
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.home),
        //   label: 'Home',
        //   backgroundColor: Color.fromARGB(255, 93, 23, 105),
        // ),
      ),
    );
  }
}
