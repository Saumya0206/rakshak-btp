import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';
import 'package:rakshak/main_screens/PopupResult.dart';
import 'package:flutter/services.dart';
import 'package:rakshak/main_screens/connection_serial/ConnectionSerial.dart';

// Telestethoscope
import 'package:rakshak/main_screens/telestethoscope/RecordPage.dart';

late User loggedInUser;

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('R A K S H A K', style: TextStyle(fontSize: 40)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 38, 128),
        foregroundColor: Colors.white,
        elevation: 1.0,
      ),
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
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // Fixed
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
