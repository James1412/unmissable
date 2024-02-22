import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModeViewModel extends ChangeNotifier {
  ThemeMode darkMode = ThemeMode.dark;

  void setDarkMode(ThemeMode mode) {
    darkMode = mode;
    notifyListeners();
  }
}

bool isDarkMode(BuildContext context) {
  return context.watch<DarkModeViewModel>().darkMode == ThemeMode.dark;
}

bool isSystemDark(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.dark;
}
