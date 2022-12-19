import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';
// import 'package:rakshak/main_screens/Connection.dart';
import 'package:rakshak/main_screens/connection_serial/ConnectionSerial.dart';

class HomePage extends StatefulWidget {
  static String id = "/HomePage";

  static const IconData heart = IconData(0xf442,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // for calling feature discovery immediately when page opens
  // initState() {
  //   print('im here');
  // SchedulerBinding.instance.addPostFrameCallback((_) {
  //   FeatureDiscovery.discoverFeatures(
  //     context,
  //     const <String>[
  //       'system',
  //       'reading',
  //     ],
  //   );
  // });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RAKSHAK'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            onPressed: () {
              print("yep");
              FeatureDiscovery.discoverFeatures(
                context,
                const <String>{
                  'system',
                  'reading',
                },
              );
            },
            child: const Text(
              'initState Demonstration',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConnectionSerial(),
                ),
              );
            },
            child: const Text(
              'Go to Connection page',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConnectionSerial(),
                ),
              );
            },
            child: const Text(
              'Go to Stethoscope page',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'System',
            icon: DescribedFeatureOverlay(
              featureId: 'system',
              targetColor: Colors.white,
              textColor: Colors.black,
              backgroundColor: Colors.red,
              contentLocation: ContentLocation.trivial,
              title: Text(
                'This is System page',
                style: TextStyle(fontSize: 20.0),
              ),
              pulseDuration: Duration(seconds: 1),
              enablePulsingAnimation: true,
              overflowMode: OverflowMode.extendBackground,
              openDuration: Duration(seconds: 1),
              description: Text('This is System Page'),
              tapTarget: Icon(Icons.cloud),
              child: Icon(Icons.cloud),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Reading',
            icon: DescribedFeatureOverlay(
              featureId: 'reading',
              targetColor: Colors.white,
              textColor: Colors.black,
              backgroundColor: Colors.red,
              contentLocation: ContentLocation.trivial,
              title: Text(
                'This is Button',
                style: TextStyle(fontSize: 20.0),
              ),
              pulseDuration: Duration(seconds: 1),
              enablePulsingAnimation: true,
              overflowMode: OverflowMode.extendBackground,
              openDuration: Duration(seconds: 1),
              description: Text('This is another page'),
              tapTarget: Icon(Icons.search),
              child: Icon(Icons.search),
            ),
            // label: 'Reading',
          ),
        ],
      ),
    );
  }
}
