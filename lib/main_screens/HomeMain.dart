import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';
import 'package:rakshak/main_screens/PopupResult.dart';
import 'package:flutter/services.dart';
import 'package:rakshak/main_screens/ResultPage.dart';
import 'package:rakshak/main_screens/connection_serial/ConnectionSerial.dart';
import 'package:feature_discovery/feature_discovery.dart';

// Telestethoscope
import 'package:rakshak/main_screens/telestethoscope/RecordPage.dart';

late User loggedInUser;
int _index = 0;

// ignore: must_be_immutable
class HomeMain extends StatefulWidget {
  static String id = '/HomeMain';

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
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
    Widget child = Container();

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
        child = FlutterLogo();
        onPressed:
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(),
            ),
          );
        };
        break;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        color: Colors.blueAccent,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/background.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 60.0, bottom: 70.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            loggedInUser.displayName.toString(),
                            style: const TextStyle(fontSize: 25.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Text(
                            'Email: ',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            loggedInUser.email.toString(),
                            style: const TextStyle(fontSize: 25.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecordPage(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset('assets/images/HeartRate.png',
                                width: 305.0, height: 200.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            // Navigator.pushNamed(context, ConnectionSerial.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConnectionSerial(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset('assets/images/POTMeasure.png',
                                width: 360.0, height: 155.0),
                          ),
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
      // bottomNavigationBar: BottomNavigationBar(
      // toolbarHeight: 70,
    );
  }
}
