import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/main_screens/sensor/Max30102.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rakshak/main_screens/ListItem.dart';

// firestore collection
CollectionReference satReading =
    FirebaseFirestore.instance.collection('saturation');

class ResultPage extends StatefulWidget {
  static String id = "/results";

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Max30102> result = List.empty(growable: true);
  List<Timestamp> result_time = List.empty(growable: true);
  bool loading = true;

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await satReading.get();
    final allData = querySnapshot.docs.map((doc) => doc).toList();

    // initialize the arrays with fetched values
    for (int i = 0; i < allData.length; i++) {
      result.add(Max30102(
          allData[i]["spo2"], allData[i]["pulse"], allData[i]["temp"]));
      result_time.add(allData[i]['timestamp']);
    }

    // update state
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Text("loading")
          : ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                for (int i = 0; i < result.length; i++)
                  ListItem(result[i].spo2.toString(), result[i].temp.toString(),
                      result[i].pulse.toString(), result_time[i].toString())
              ],
            ),
    );
  }
}
