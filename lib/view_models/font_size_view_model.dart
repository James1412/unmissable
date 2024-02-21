import 'package:flutter/cupertino.dart';

class FontSizeViewModel extends ChangeNotifier {
  double fontSize = 16.0;

  void setFontSize(double val) {
    fontSize = val;
    notifyListeners();
  }
}
