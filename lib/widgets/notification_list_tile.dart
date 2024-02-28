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

Widget notificationListTile(
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
          showDialog(
            context: context,
            builder: (context) => const AlertDialog.adaptive(
              content: Text("Cleared"),
            ),
          );
        },
        title: Text(
          "Clear all notifications",
          style: TextStyle(
            color: isDarkMode(context) ? Colors.white : darkModeBlack,
          ),
        ),
      ),
      if (Platform.isIOS)
        CupertinoListTile(
          leading: Icon(
            CupertinoIcons.list_bullet,
            color: isDarkMode(context) ? Colors.white : darkModeBlack,
          ),
          onTap: () {
            if (Platform.isIOS) {
              HapticFeedback.lightImpact();
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsPage(),
                ));
          },
          title: Text(
            "Settings on iPhone",
            style: TextStyle(
              color: isDarkMode(context) ? Colors.white : darkModeBlack,
            ),
          ),
          trailing: const CupertinoListTileChevron(),
        ),
    ],
  );
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Go to Unmissable notification in settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Go to Notification Grouping at the bottom",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Expanded(
                      child: Container(
                        height: 510,
                        width: 250,
                        decoration: const BoxDecoration(),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/intro1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Switch to off",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "This will show the full list of notes without grouping them in one notification",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Expanded(
                      child: Container(
                        height: 490,
                        width: 250,
                        decoration: const BoxDecoration(),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/intro2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabPageSelector(
                color: Colors.red.shade100,
                selectedColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
