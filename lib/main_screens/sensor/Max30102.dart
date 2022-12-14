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
}
