import 'package:flutter/material.dart';
import 'package:rakshak/main_screens/HomePage.dart';
import 'package:rakshak/main_screens/LoginPage.dart';
import 'package:rakshak/main_screens/Measurement.dart';
import 'package:rakshak/main_screens/O2.dart';
import 'package:rakshak/main_screens/connection_serial/ConnectionSerial.dart';
import 'package:rakshak/results_screen/Done.dart';
import 'package:rakshak/results_screen/ForgotPassword.dart';
import 'package:rakshak/main_screens/RegisterPage.dart';

// external packages
import 'package:firebase_core/firebase_core.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Home());
  configLoading();
}

// EasyLoading initialization
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      recordStepsInSharedPreferences: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Abel'),

        // for testing
        // change this line to get any starting page you want
        initialRoute: RegisterPage.id,

        routes: {
          HomePage.id: (context) => HomePage(),
          RegisterPage.id: (context) => RegisterPage(),
          LoginPage.id: (context) => LoginPage(),
          ForgotPassword.id: (context) => ForgotPassword(),
          Done.id: (context) => Done(),
          Measurement.id: (context) => Measurement(),
          // ConnectionSerial.id:(context) => ConnectionSerial(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
