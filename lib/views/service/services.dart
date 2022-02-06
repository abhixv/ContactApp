import 'dart:math';
import 'package:flutter/material.dart';

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
