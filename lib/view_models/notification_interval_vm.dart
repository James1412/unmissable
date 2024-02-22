import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/repos/notification_interval_repo.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class NotificationIntervalViewModel extends ChangeNotifier {
  final db = NotificationIntervalRepository();
  late RepeatInterval interval =
      db.getNotiInterval() == RepeatInterval.everyMinute.toString()
          ? RepeatInterval.everyMinute
          : db.getNotiInterval() == RepeatInterval.hourly.toString()
              ? RepeatInterval.hourly
              : RepeatInterval.daily;

  void setInterval(RepeatInterval repeatInterval, BuildContext context) {
    interval = repeatInterval;
    db.setNotiInterval(repeatInterval);
    context.read<NotesViewModel>().notificationOnHelper(context);
    notifyListeners();
  }
}
