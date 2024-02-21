import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unmissable/screens/deleted_notes_screen.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';
import 'package:unmissable/widgets/dark_mode_list_tile.dart';
import 'package:unmissable/widgets/feedback_list_tile.dart';
import 'package:unmissable/widgets/font_size_list_tile.dart';
import 'package:unmissable/widgets/notification_repeat_interval_list_tile.dart';
import 'package:unmissable/widgets/sort_notes_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

void onMoreTap({required BuildContext context}) {
  final double modalHeight = MediaQuery.of(context).size.height * 0.85;
  if (Platform.isIOS) {
    HapticFeedback.lightImpact();
  }
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoModalPopupSheet(
      height: modalHeight,
      child: Column(
        children: [
          CupertinoListSection.insetGrouped(
            header: Text(
              "WIDGET",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            children: [
              CupertinoListTile(
                leading: Icon(
                  Icons.widgets,
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
                title: Text(
                  "How to use widget?",
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
                trailing: const CupertinoListTileChevron(),
                onTap: () async {
                  if (Platform.isAndroid) {
                    await launchUrl(Uri.parse(
                        "https://guidebooks.google.com/android/customizeyourphone/addwidgets"));
                  }
                  if (Platform.isIOS) {
                    await launchUrl(
                        Uri.parse("https://support.apple.com/en-ca/HT207122"));
                  }
                },
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text(
              "STYLE",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            children: [
              darkModeListTile(context: context, modalHeight: modalHeight),
              fontSizeListTile(context: context, modalHeight: modalHeight),
              sortNotesListTile(context: context, modalHeight: modalHeight),
            ],
          ),
          notificationRepeatIntervalListTile(
              context: context, modalHeight: modalHeight),
          CupertinoListSection.insetGrouped(
            header: Text(
              "ACCOUNT",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            children: [
              CupertinoListTile(
                leading: Icon(
                  Icons.person,
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
                title: Text(
                  "Sign up & Log in",
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
                trailing: const CupertinoListTileChevron(),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text(
              "TRASH",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            children: [
              CupertinoListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Deleted notes",
                  style: TextStyle(color: Colors.red),
                ),
                trailing: const CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DeletedNotesScreen()));
                },
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text(
              "FEEDBACK",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            children: [
              feedbackListTile(context: context),
              CupertinoListTile(
                leading: Icon(
                  Icons.contact_mail,
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
                title: Text(
                  "Developer's contact",
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
                trailing: const CupertinoListTileChevron(),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text(
              "ABOUT",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            children: [
              CupertinoListTile(
                leading: Icon(
                  Icons.info,
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
                title: Text(
                  "About",
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
                trailing: const CupertinoListTileChevron(),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "Unmissable",
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    ),
  );
}
