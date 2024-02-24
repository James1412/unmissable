// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unmissable/repos/firebase_auth.dart';
import 'package:unmissable/screens/auth_introduction_page.dart';
import 'package:unmissable/utils/themes.dart';

Widget accountListTile(BuildContext context) {
  return CupertinoListSection.insetGrouped(
    header: Text(
      "ACCOUNT",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
      ),
    ),
    children: [
      if (FirebaseAuth.instance.currentUser == null)
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
          onTap: () {
            if (Platform.isIOS) {
              HapticFeedback.lightImpact();
            }
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FadeTransition(
                    opacity: animation,
                    child: const SignupLoginScreen(),
                  );
                },
              ),
            );
          },
          trailing: const CupertinoListTileChevron(),
        ),
      if (FirebaseAuth.instance.currentUser != null) ...[
        CupertinoListTile(
          leading: Icon(
            Icons.logout,
            color: isDarkMode(context) ? Colors.white : darkModeBlack,
          ),
          title: Text(
            "Sign out",
            style: TextStyle(
              color: isDarkMode(context) ? Colors.white : darkModeBlack,
            ),
          ),
          onTap: () async {
            if (Platform.isIOS) {
              HapticFeedback.lightImpact();
            }
            await showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Sign Out?"),
                content: const Text("This will stop sharing the notes"),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text("Yes"),
                    onPressed: () async {
                      await FirebaseAuthentication().signOut();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          trailing: const CupertinoListTileChevron(),
        ),
        if (FirebaseAuth.instance.currentUser != null)
          CupertinoListTile(
            leading: Icon(
              Icons.person_off,
              color: isDarkMode(context) ? Colors.white : darkModeBlack,
            ),
            title: Text(
              "Delete account",
              style: TextStyle(
                color: isDarkMode(context) ? Colors.white : darkModeBlack,
              ),
            ),
            onTap: () async {
              if (Platform.isIOS) {
                HapticFeedback.lightImpact();
              }
              await showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Delete the account?"),
                  content:
                      const Text("This will permanently delete the account"),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                      onPressed: () async {
                        await FirebaseAuthentication().deleteAccount();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
            trailing: const CupertinoListTileChevron(),
          ),
      ]
    ],
  );
}
