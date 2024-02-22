import 'package:flutter/cupertino.dart';
import 'package:unmissable/repos/font_size_repo.dart';

class FontSizeViewModel extends ChangeNotifier {
  final db = FontSizeRepository();
  late double fontSize = db.getFontSize();

  void setFontSize(double val) {
    fontSize = val;
    db.setFontSize(val);
    notifyListeners();
  }
}
