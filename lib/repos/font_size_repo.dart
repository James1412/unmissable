import 'package:hive_flutter/hive_flutter.dart';
import 'package:unmissable/utils/hive_box_names.dart';

final fontSizeBox = Hive.box(fontSizeBoxName);

class FontSizeRepository {
  Future<void> setFontSize(double fontSize) async {
    await fontSizeBox.put(fontSizeBoxName, fontSize);
  }

  double getFontSize() {
    return fontSizeBox.get(fontSizeBoxName) ?? 16.0;
  }
}
