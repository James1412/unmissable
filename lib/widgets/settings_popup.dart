import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:unmissable/screens/deleted_notes_screen.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/widgets/account_list_tile.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';
import 'package:unmissable/widgets/feedback_list_tile.dart';
import 'package:unmissable/widgets/font_size_list_tile.dart';
import 'package:unmissable/widgets/notification_list_tile.dart';
import 'package:unmissable/widgets/sort_notes_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

void onSettingsTap(
    {required BuildContext context, required bool isSubscribed}) {
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
              "ADS",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            children: [
              CupertinoListTile(
                leading: Icon(
                  Icons.ad_units_rounded,
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
                title: Text(
                  isSubscribed ? "Ads removed!" : "Remove ads",
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
                trailing:
                    isSubscribed ? null : const CupertinoListTileChevron(),
                onTap: isSubscribed
                    ? () {
                        Purchases.logOut();
                      }
                    : () async {
                        bool result =
                            await InternetConnection().hasInternetAccess;
                        if (!result) {
                          await showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) => const AlertDialog.adaptive(
                              title: Text("Internect Connection Issue"),
                              content:
                                  Text("Please connect to internet to proceed"),
                            ),
                          );
                          return;
                        }
                        try {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator.adaptive()),
                          );
                          // ignore: deprecated_member_use
                          await Purchases.purchaseProduct(
                            'unmissable_5_lifetime_remove_ads',
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } on PlatformException catch (e) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) => AlertDialog.adaptive(
                              content: Text(e.message.toString()),
                            ),
                          );
                        }
                      },
              ),
              if (!isSubscribed)
                CupertinoListTile(
                  leading: Icon(
                    Icons.restore,
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                  title: Text(
                    "Restore purchase",
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () async {
                    try {
                      await Purchases.restorePurchases();
                    } on PlatformException catch (e) {
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog.adaptive(
                          content: Text(e.message as String),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
          if (Platform.isIOS)
            //TODO: Implement Android widget
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
                      await launchUrl(Uri.parse(
                          "https://support.apple.com/en-ca/HT207122"));
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
              fontSizeListTile(context: context, modalHeight: modalHeight),
              sortNotesListTile(context: context, modalHeight: modalHeight),
              CupertinoListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
                title: Text(
                  "How to use dark mode?",
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
                trailing: const CupertinoListTileChevron(),
                onTap: () async {
                  if (Platform.isAndroid) {
                    await launchUrl(Uri.parse(
                        "https://support.google.com/android/answer/9730472?hl=en"));
                  }
                  if (Platform.isIOS) {
                    await launchUrl(
                        Uri.parse("https://support.apple.com/en-ca/108350"));
                  }
                },
              ),
            ],
          ),
          notificationListTile(context: context, modalHeight: modalHeight),
          accountListTile(context),
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
                  if (Platform.isIOS) {
                    HapticFeedback.lightImpact();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeletedNotesScreen()),
                  );
                },
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text(
              "OTHERS",
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
