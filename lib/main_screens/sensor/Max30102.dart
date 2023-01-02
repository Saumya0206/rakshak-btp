import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Max30102 {
  late int spo2;
  late int pulse;
  late double temp;

  Max30102(int spo2, int pulse, double temp) {
    this.spo2 = spo2;
    this.pulse = pulse;
    this.temp = temp;
  }

  void add(Max30102 other) {
    this.pulse += other.pulse;
    this.spo2 += other.spo2;
    this.temp += other.temp;
  }

  Max30102 setSpo2(int spo2) {
    this.spo2 = spo2;
    return this;
  }

  Max30102 setPulse(int pulse) {
    this.pulse = pulse;
    return this;
  }

  Max30102 setTemp(double temp) {
    this.temp = temp;
    return this;
  }

  int getSpo2() {
    return spo2;
  }

  int getPulse() {
    return pulse;
  }

  double getTemp() {
    return temp;
  }

  void divBy(int x) {
    this.pulse = (this.pulse / x).floor();
    this.spo2 = (this.spo2 / x).floor();
    this.temp = ((this.temp / x * 100)) / 100.0;
  }

  @override
  String toString() {
    return "spo2:$spo2 temp:$temp pulse:$pulse";
  }
}
