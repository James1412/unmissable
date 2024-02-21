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

Color darkModeBlack = const Color(0xff1C1C1E);
Color lessdarkBlack = const Color(0xff3A3A3B);
Color darkModeGrey = const Color(0xff8E8E93);
Color headerGreyColor = Colors.black38;
