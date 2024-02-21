import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

Widget darkModeListTile({required context, required double modalHeight}) {
  return CupertinoListTile(
    leading: const Icon(Icons.dark_mode),
    title: const Text("Dark mode"),
    onTap: () {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            DarkMode darkMode =
                Provider.of<DarkModeViewModel>(context, listen: false).darkMode;
            return CupertinoModalPopupSheet(
              height: modalHeight,
              child: CupertinoListSection.insetGrouped(
                additionalDividerMargin: 0.0,
                dividerMargin: 0.0,
                children: [
                  CupertinoListTile(
                    onTap: () {
                      context
                          .read<DarkModeViewModel>()
                          .setDarkMode(DarkMode.light);
                      setState(() {});
                    },
                    title: const Text("Light Mode"),
                    trailing: darkMode == DarkMode.light
                        ? const Icon(CupertinoIcons.check_mark)
                        : null,
                  ),
                  CupertinoListTile(
                    onTap: () {
                      context
                          .read<DarkModeViewModel>()
                          .setDarkMode(DarkMode.dark);
                      setState(() {});
                    },
                    title: const Text("Dark Mode"),
                    trailing: darkMode == DarkMode.dark
                        ? const Icon(CupertinoIcons.check_mark)
                        : null,
                  ),
                  CupertinoListTile(
                    onTap: () {
                      context
                          .read<DarkModeViewModel>()
                          .setDarkMode(DarkMode.system);
                      setState(() {});
                    },
                    title: const Text("System Mode"),
                    trailing: darkMode == DarkMode.system
                        ? const Icon(CupertinoIcons.check_mark)
                        : null,
                  ),
                ],
              ),
            );
          });
        },
      );
    },
    trailing: const CupertinoListTileChevron(),
  );
}
