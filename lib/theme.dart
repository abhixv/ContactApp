import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light(BuildContext context) => ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.white,
      ),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      canvasColor: Colors.grey);

  static ThemeData dark(BuildContext context) => ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        elevation: 0.0,
      ),
      brightness: Brightness.dark,
      backgroundColor: Colors.black,
      accentColor: Colors.white,
      canvasColor: Colors.grey);
}
