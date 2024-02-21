import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    textTheme: Typography.blackHelsinki,
    brightness: Brightness.light,
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    textTheme: Typography.whiteHelsinki,
    brightness: Brightness.dark,
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.black,
      shadowColor: Colors.black,
    ),
  );
}
