import 'dart:io';

class AdHelper {
  static String get banner1AdUnitId {
    if (Platform.isAndroid) {
      // TODO: Change Android
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/8255829119';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get banner2AdUnitId {
    if (Platform.isAndroid) {
      // TODO: Change Android
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/2194651943';
    }
    throw UnsupportedError("Unsupported platform");
  }
}

//TODO: Change on deployment
bool showAds = true;
