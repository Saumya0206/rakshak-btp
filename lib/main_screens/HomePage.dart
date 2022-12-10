import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  static String id = "/HomePage";

  static const IconData heart = IconData(0xf442,
      fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    print('im here');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>[
          'system',
          'reading',
        ],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RAKSHAK'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        elevation: 0.0,
      ),
      body: Center(
          child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green)),
        onPressed: () {},
        child: const Text(
          'initState Demonstration',
          style: TextStyle(color: Colors.white),
        ),
      )),
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
                  'This is Icon',
                  style: TextStyle(fontSize: 20.0),
                ),
                pulseDuration: Duration(seconds: 1),
                enablePulsingAnimation: true,
                overflowMode: OverflowMode.extendBackground,
                openDuration: Duration(seconds: 1),
                description:
                    Text('This is Button you can\n add more details heres'),
                tapTarget: Icon(Icons.navigation),
                child: Icon(Icons.cloud),
              )

              // Icon(Icons.cloud),
              // label: 'System',
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
                description:
                    Text('This is Button you can\n add more details heres'),
                tapTarget: Icon(Icons.navigation),
                child: Icon(Icons.cloud),
              )
              // label: 'Reading',
              ),
        ],
      ),
    );
  }
}
