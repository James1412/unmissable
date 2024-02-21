import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModeViewModel extends ChangeNotifier {
  ThemeMode darkMode = ThemeMode.system;

  void setDarkMode(ThemeMode mode) {
    darkMode = mode;
    notifyListeners();
  }
}

bool isDarkMode(BuildContext context) {
  if (context.watch<DarkModeViewModel>().darkMode == ThemeMode.system) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  } else {
    return context.watch<DarkModeViewModel>().darkMode == ThemeMode.dark;
  }
}
