import 'package:flutter/cupertino.dart';
import 'package:unmissable/utils/enums.dart';

class DarkModeViewModel extends ChangeNotifier {
  DarkMode darkMode = DarkMode.system;

  void setDarkMode(DarkMode mode) {
    darkMode = mode;
    notifyListeners();
  }
}
