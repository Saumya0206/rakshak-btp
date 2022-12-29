import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_blue/gen/flutterblue.pb.dart';

import 'package:rakshak/main_screens/ConnectionDone.dart';

class Connection extends StatelessWidget {
  static String id = "/connect";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              // return Center(child: Text("On"));
              return FindDevicesScreen();
            } else {
              print("here");
              // return Center(child: Text("Off"));
              return BluetoothOffScreen(state: state);
            }
          }),
      //   ],
      // ),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.bluetooth_disabled,
            size: 200.0,
            color: Colors.white54,
          ),
          Text(
            'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
          ),
        ],
      ),
      // Text("data"),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Find Devices', style: TextStyle(fontSize: 30)),
        backgroundColor: const Color.fromARGB(255, 93, 23, 105),
        foregroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.bluetooth),
        ),
      ),
      body: SizedBox(
        // height: 200,
        // width: 100,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, bottom: 70.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Image.asset('assets/images/bluetooth.png',
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Text(
                                  'Turn on your blutooth & click on the search button for a bluetooth device',
                                  style: TextStyle(fontSize: 10.0),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) => SizedBox(
                width: 100,
                height: 200,
                child: Column(
                  children: snapshot.data!
                      .map((result) => ListTile(
                            title: Text(result.device.name == ""
                                ? "No Name "
                                : result.device.name),
                            subtitle: Text(result.device.id.toString()),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  result.device.connect();
                                  // return Text(result.device.name);
                                  return ConnectionDone(result.device);
                                },
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 100,
        width: 100,
        child: SizedBox(
          height: 100,
          width: 100,
          child: StreamBuilder<bool>(
            stream: FlutterBluePlus.instance.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data!) {
                return FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () => {
                    FlutterBluePlus.instance.stopScan(),
                  },
                  backgroundColor: Colors.red,
                );
              } else {
                return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () => FlutterBluePlus.instance.startScan(
                    timeout: Duration(seconds: 10),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
