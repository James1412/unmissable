import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unmissable/utils/hive_box_names.dart';

final notificationIntervalBox = Hive.box(notificationIntervalBoxName);

class NotificationIntervalRepository {
  Future<void> setNotiInterval(RepeatInterval interval) async {
    await notificationIntervalBox.put(
        notificationIntervalBoxName, interval.toString());
  }

  String getNotiInterval() {
    return notificationIntervalBox.get(notificationIntervalBoxName) ??
        RepeatInterval.hourly.toString();
  }
}
