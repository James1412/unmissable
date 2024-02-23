import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:url_launcher/url_launcher.dart';

Widget feedbackListTile({required BuildContext context}) {
  return CupertinoListTile(
    leading: Icon(
      Icons.feedback,
      color: isDarkMode(context) ? Colors.white : darkModeBlack,
    ),
    title: Text("Leave feedback",
        style: TextStyle(
          color: isDarkMode(context) ? Colors.white : darkModeBlack,
        )),
    trailing: const CupertinoListTileChevron(),
    onTap: () async {
      String emailAddress = "jigang1005@gmail.com";
      String? encodeQueryParameters(Map<String, String> params) {
        return params.entries
            .map((MapEntry<String, String> e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
        query: encodeQueryParameters(
          <String, String>{
            'subject': 'Feedback: Unmissable',
          },
        ),
      );
      if (await canLaunchUrl(emailLaunchUri)) {
        launchUrl(emailLaunchUri);
      }
    },
  );
}
