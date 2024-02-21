import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    textTheme: Typography.blackHelsinki,
    brightness: Brightness.light,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    textTheme: Typography.whiteHelsinki,
    brightness: Brightness.dark,
  );
}
