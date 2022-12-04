import 'package:flutter/material.dart';

class MyPopup extends StatefulWidget {
  String title = "Thank You!";
  String message = "Your average O2 saturation is: ";
  int result;
  List<Widget> actions;

  MyPopup({this.title, this.message, this.result, this.actions = const []});

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(this.title, style: Theme.of(context).textTheme.bodyText1,),
      content: Text(this.message+this.result.toString(), style: Theme.of(context).textTheme.bodyText1,),
      actions: this.actions,
    )
  }
}
