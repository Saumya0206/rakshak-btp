import 'package:flutter/material.dart';
import 'package:rakshak/main_screens/LoginPage.dart';
import 'package:rakshak/main_screens/Measurement.dart';
import 'package:rakshak/results_screen/Done.dart';
import 'package:rakshak/results_screen/ForgotPassword.dart';
import 'package:rakshak/main_screens/RegisterPage.dart';

// new code
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // new code
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Abel'),
      initialRoute: RegisterPage.id,
      routes: {
        RegisterPage.id: (context) => RegisterPage(),
        LoginPage.id: (context) => LoginPage(),
        ForgotPassword.id: (context) => ForgotPassword(),
        Done.id: (context) => Done(),
        Measurement.id: (context) => Measurement(),
      },
    );
  }
}




// OLD PRACTICE CODE

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Home(),
//   ));
// }

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('RAKSHAK'),
//         centerTitle: true,
//         backgroundColor: Colors.red[600],
//         elevation: 0.0,
//       ),
//       body: Row(
//         children: <Widget>[
//           Expanded(flex: 3, child: Image.asset('assets/island.png')),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.all(30.0),
//               color: Colors.cyan,
//               child: Text('1'),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.all(30.0),
//               color: Colors.pinkAccent,
//               child: Text('2'),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.all(30.0),
//               color: Colors.amber,
//               child: Text('3'),
//             ),
//           ),
//         ],
//       ),

//       // Column(
//       //     mainAxisAlignment: MainAxisAlignment.end,
//       //     crossAxisAlignment: CrossAxisAlignment.end,
//       //     children: <Widget>[
//       //       Row(
//       //         children: <Widget>[Text('hello'), Text('row')],
//       //       ),
//       //       Container(
//       //           padding: EdgeInsets.all(20.0),
//       //           color: Colors.cyan,
//       //           child: Text('one')),
//       //       Container(
//       //           padding: EdgeInsets.all(30.0),
//       //           color: Colors.pinkAccent,
//       //           child: Text('two')),
//       //       Container(
//       //           padding: EdgeInsets.all(40.0),
//       //           color: Colors.amber,
//       //           child: Text('three')),
//       //     ]),

//       // Row(
//       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //   crossAxisAlignment: CrossAxisAlignment.start,
//       //   children: <Widget>[
//       //     Text('Hello'),
//       //     TextButton(
//       //       child: Text('click'),
//       //       style: ButtonStyle(
//       //           backgroundColor: MaterialStateProperty.all(Colors.red[300])),
//       //       onPressed: () {},
//       //     ),
//       //     Container(
//       //         color: Colors.cyan,
//       //         padding: EdgeInsets.all(30.0),
//       //         child: Text('Inside container'))
//       //   ],
//       // ),

//       // Padding(child: Text('hello'), padding: EdgeInsets.all(90.0)),

//       // Container(
//       //     child: Text('hello'),
//       //     margin: EdgeInsets.all(30.0),
//       //     padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
//       //     color: Colors.grey[400]),

//       // Center(
//       //     child: IconButton(
//       //   onPressed: () {},
//       //   icon: Icon(Icons.alternate_email),
//       //   color: Colors.amber,
//       // )

//       // ElevatedButton.icon(
//       //   onPressed: () {},
//       //   icon: Icon(Icons.mail),
//       //   label: Text('Mail Me'),
//       // ),

//       // Icon(Icons.airport_shuttle, color: Colors.lightBlue, size: 50.0)

//       // Image.asset('assets/titanic_rising.jpg'),

//       // Text(
//       //   "Body Text",
//       //   style: TextStyle(
//       //       fontSize: 20,
//       //       fontWeight: FontWeight.bold,
//       //       letterSpacing: 2.0,
//       //       color: Colors.grey[600],
//       //       fontFamily: 'Livvic'),
//       // ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Text('click'),
//         backgroundColor: Colors.red[600],
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter += 2;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
