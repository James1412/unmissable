import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/view_models/notification_interval_vm.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

Widget notificationRepeatIntervalListTile(
    {required BuildContext context, required double modalHeight}) {
  return CupertinoListSection.insetGrouped(
    header: Text(
      "NOTIFICATION",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
      ),
    ),
    children: [
      CupertinoListTile(
        leading: Icon(
          CupertinoIcons.bell_fill,
          color: isDarkMode(context) ? Colors.white : darkModeBlack,
        ),
        title: Text(
          "Notification interval",
          style: TextStyle(
            color: isDarkMode(context) ? Colors.white : darkModeBlack,
          ),
        ),
        trailing: const CupertinoListTileChevron(),
        onTap: () {
          if (Platform.isIOS) {
            HapticFeedback.lightImpact();
          }
          showCupertinoModalPopup(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                RepeatInterval interval =
                    Provider.of<NotificationIntervalViewModel>(context,
                            listen: false)
                        .interval;
                return CupertinoModalPopupSheet(
                  height: modalHeight,
                  child: CupertinoListSection.insetGrouped(
                    additionalDividerMargin: 0.0,
                    dividerMargin: 0.0,
                    children: [
                      CupertinoListTile(
                        onTap: () {
                          context
                              .read<NotificationIntervalViewModel>()
                              .setInterval(RepeatInterval.everyMinute, context);
                          setState(() {});
                        },
                        title: Text(
                          "Every minute",
                          style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white
                                : darkModeBlack,
                          ),
                        ),
                        trailing: interval == RepeatInterval.everyMinute
                            ? Icon(
                                CupertinoIcons.check_mark,
                                color: isDarkMode(context)
                                    ? darkModeGrey
                                    : darkModeBlack,
                              )
                            : null,
                      ),
                      CupertinoListTile(
                        onTap: () {
                          context
                              .read<NotificationIntervalViewModel>()
                              .setInterval(RepeatInterval.hourly, context);
                          setState(() {});
                        },
                        title: Text(
                          "Hourly",
                          style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white
                                : darkModeBlack,
                          ),
                        ),
                        trailing: interval == RepeatInterval.hourly
                            ? Icon(
                                CupertinoIcons.check_mark,
                                color: isDarkMode(context)
                                    ? darkModeGrey
                                    : darkModeBlack,
                              )
                            : null,
                      ),
                      CupertinoListTile(
                        onTap: () {
                          context
                              .read<NotificationIntervalViewModel>()
                              .setInterval(RepeatInterval.daily, context);
                          setState(() {});
                        },
                        title: Text(
                          "Daily",
                          style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white
                                : darkModeBlack,
                          ),
                        ),
                        trailing: interval == RepeatInterval.daily
                            ? Icon(
                                CupertinoIcons.check_mark,
                                color: isDarkMode(context)
                                    ? darkModeGrey
                                    : darkModeBlack,
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      CupertinoListTile(
        leading: Icon(
          CupertinoIcons.bell_slash_fill,
          color: isDarkMode(context) ? Colors.white : darkModeBlack,
        ),
        onTap: () {
          if (Platform.isIOS) {
            HapticFeedback.lightImpact();
          }
          context.read<NotesViewModel>().notificationAllOff();
        },
        title: Text(
          "Clear all notifications",
          style: TextStyle(
            color: isDarkMode(context) ? Colors.white : darkModeBlack,
          ),
        ),
      ),
    ],
  );
}
