import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData customTheme = ThemeData(
    brightness: Brightness.dark, 
    primaryColor: const Color(0xFF121213),
    textTheme: const TextTheme(
      subtitle1: TextStyle(color: Color(0xFFF1F1F4)),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
      tileColor: const Color(0xFF1F1F20),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(50.0)),
    ),
    scaffoldBackgroundColor: const Color(0xFF121213),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121213),
      elevation: 0,
    ),
  );
}
