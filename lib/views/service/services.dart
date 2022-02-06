import 'dart:math';

import 'package:flutter/material.dart';

List<String> contactName = [
  "Raj",
  "Raju",
  "Sham",
  "Tonny Patil",
  "Gorge Mishra",
  "William patel"
];
List<String> contactNumber = [
  "9846376464",
  "9846376464",
  "9846376423",
  "9846376564",
  "9846375643",
  "9846374545"
];
List<String> speedDialName = [
  "Raj Kumar",
  "Raj",
  "Raju",
  "Sham",
];
List<String> speedDialNumber = [
  "1234567890",
  "9846376464",
  "9846376464",
  "9846376423",
];

List<Color> randomColor = [
  Colors.red,
  Colors.pink,
  Colors.pinkAccent,
  Colors.blue,
  Colors.blueAccent,
  Colors.blueGrey,
  Colors.lightBlue,
  Colors.lightGreen
];
T getRandomElement<T>(List<T> list) {
  final random = Random();
  var i = random.nextInt(list.length);
  return list[i];
}
