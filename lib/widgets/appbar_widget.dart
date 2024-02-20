import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  void onMoreTap({required BuildContext context}) {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const CupertinoModalPopupSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => onMoreTap(context: context),
                  child: const Icon(FontAwesomeIcons.ellipsis),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const CupertinoSearchTextField(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
