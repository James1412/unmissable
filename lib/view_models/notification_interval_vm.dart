import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class NotificationIntervalViewModel extends ChangeNotifier {
  RepeatInterval interval = RepeatInterval.hourly;

  void setInterval(RepeatInterval repeatInterval, BuildContext context) {
    interval = repeatInterval;
    context.read<NotesViewModel>().notificationOnHelper(context);
    notifyListeners();
  }
}
