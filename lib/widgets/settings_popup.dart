import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';
import 'package:unmissable/widgets/dark_mode_list_tile.dart';
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
            header: const Opacity(
              opacity: 0.6,
              child: Text(
                "WIDGET",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            children: [
              CupertinoListTile(
                leading: const Icon(Icons.widgets),
                title: const Text("How to use widget?"),
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
            header: const Opacity(
              opacity: 0.6,
              child: Text(
                "STYLE",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            children: [
              darkModeListTile(context: context, modalHeight: modalHeight),
              const CupertinoListTile(
                leading: Icon(Icons.text_increase),
                title: Text("Font size"),
                trailing: CupertinoListTileChevron(),
              ),
              const CupertinoListTile(
                leading: Icon(Icons.sort),
                title: Text("Sort notes"),
                trailing: CupertinoListTileChevron(),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Opacity(
              opacity: 0.6,
              child: Text(
                "ACCOUNT",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            children: const [
              CupertinoListTile(
                leading: Icon(Icons.person),
                title: Text("Sign up & Log in"),
                trailing: CupertinoListTileChevron(),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Opacity(
              opacity: 0.6,
              child: Text(
                "FEEDBACK",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            children: const [
              CupertinoListTile(
                leading: Icon(Icons.feedback, color: Colors.red),
                title:
                    Text("Leave feedback", style: TextStyle(color: Colors.red)),
                trailing: CupertinoListTileChevron(),
              ),
              CupertinoListTile(
                leading: Icon(Icons.contact_mail),
                title: Text("Developer's contact"),
                trailing: CupertinoListTileChevron(),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Opacity(
              opacity: 0.6,
              child: Text(
                "ABOUT",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            children: [
              CupertinoListTile(
                leading: const Icon(Icons.info),
                title: const Text("About"),
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
        ],
      ),
    ),
  );
}
