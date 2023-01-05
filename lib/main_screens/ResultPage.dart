import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/main_screens/sensor/Max30102.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rakshak/main_screens/ListItem.dart';

CollectionReference satReading =
    FirebaseFirestore.instance.collection('saturation');

class ResultPage extends StatefulWidget {
  static String id = "/results";

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Max30102> result = List.empty(growable: true);
  bool loading = true;

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await satReading.get();
    final allData = querySnapshot.docs.map((doc) => doc).toList();
    for (int i = 0; i < allData.length; i++) {
      result.add(Max30102(
          allData[i]["spo2"], allData[i]["pulse"], allData[i]["temp"]));
      // print(allData[i]!["pulse"]);
    }
    setState(() {
      loading = false;
    });
    // print(allData);
  }

  // List<Widget> getValues(QuerySnapshot) {

  // }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Text("loading")
          : ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                for (var item in result)
                  ListItem(item.spo2.toString(), item.temp.toString(),
                      item.pulse.toString())
              ],
            ),
    );
  }
}
