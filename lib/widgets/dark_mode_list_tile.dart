import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

Widget darkModeListTile({required context, required double modalHeight}) {
  return CupertinoListTile(
    leading: const Icon(Icons.dark_mode),
    title: Text(
      "Dark mode",
      style: TextStyle(
        color: isDarkMode(context) ? Colors.white : darkModeBlack,
      ),
    ),
    onTap: () {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            ThemeMode darkMode =
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
                          .setDarkMode(ThemeMode.light);
                      setState(() {});
                    },
                    title: Text(
                      "Light Mode",
                      style: TextStyle(
                        color:
                            isDarkMode(context) ? Colors.white : darkModeBlack,
                      ),
                    ),
                    trailing: darkMode == ThemeMode.light
                        ? const Icon(CupertinoIcons.check_mark)
                        : null,
                  ),
                  CupertinoListTile(
                    onTap: () {
                      context
                          .read<DarkModeViewModel>()
                          .setDarkMode(ThemeMode.dark);
                      setState(() {});
                    },
                    title: Text(
                      "Dark Mode",
                      style: TextStyle(
                        color:
                            isDarkMode(context) ? Colors.white : darkModeBlack,
                      ),
                    ),
                    trailing: darkMode == ThemeMode.dark
                        ? const Icon(CupertinoIcons.check_mark)
                        : null,
                  ),
                  CupertinoListTile(
                    onTap: () {
                      context
                          .read<DarkModeViewModel>()
                          .setDarkMode(ThemeMode.system);
                      setState(() {});
                    },
                    title: Text(
                      "System Mode",
                      style: TextStyle(
                        color:
                            isDarkMode(context) ? Colors.white : darkModeBlack,
                      ),
                    ),
                    trailing: darkMode == ThemeMode.system
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
