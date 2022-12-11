import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/results_screen/ForgotPassword.dart';
import 'package:rakshak/results_screen/GoogleDone.dart';
import 'package:rakshak/main_screens/RegisterPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../results_screen/Done.dart';
import 'package:rakshak/main_screens/TestPage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';
import 'package:rakshak/main_screens/PopupResult.dart';
import 'package:flutter/services.dart';

// bool _wrongEmail = false;
// bool _wrongPassword = false;

// new code: User
late User _user;

// ignore: must_be_immutable
class Measurement extends StatefulWidget {
  static String id = '/Measurement';

  @override
  _MeasurementState createState() => _MeasurementState();
}

class _MeasurementState extends State<Measurement> {
  bool _showSpinner = false;
  late int result;

  void displayDialog(BuildContext context) {
    Random random = new Random();
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
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text('R A K S H A K', style: TextStyle(fontSize: 40)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 93, 23, 105),
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
              padding: EdgeInsets.only(
                  top: 60.0, bottom: 70.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   'RAKSHAK',
                  //   style: TextStyle(fontSize: 50.0),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Email: ',
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Email: ',
                  //       style: TextStyle(fontSize: 25.0),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            displayDialog(context);
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
                            displayDialog(context);
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
            backgroundColor:
                Color.fromARGB(255, 93, 23, 105), // <-- This works for fixed
            selectedItemColor: Color.fromARGB(255, 31, 1, 38),
            unselectedItemColor: Color.fromARGB(255, 164, 100, 175),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_rounded),
                label: 'Manual',
                backgroundColor: Color.fromARGB(255, 93, 23, 105),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add_rounded),
                label: 'Reading',
                backgroundColor: Color.fromARGB(255, 93, 23, 105),
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
