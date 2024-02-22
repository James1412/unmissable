import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

Widget darkModeListTile({required context, required double modalHeight}) {
  return CupertinoListTile(
    backgroundColor:
        isDarkMode(context) ? cupertinoInsideListTile : Colors.white,
    leading: Icon(
      Icons.dark_mode,
      color: isDarkMode(context) ? Colors.white : darkModeBlack,
    ),
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
            return CustomCupertinoModalPopupSheet(
              height: modalHeight,
              child: CupertinoListSection.insetGrouped(
                additionalDividerMargin: 0.0,
                dividerMargin: 0.0,
                separatorColor:
                    isDarkMode(context) ? darkModeGrey : lightCupertino,
                backgroundColor:
                    isDarkMode(context) ? darkModeBlack : lightCupertino,
                children: [
                  CupertinoListTile(
                    backgroundColor: isDarkMode(context)
                        ? cupertinoInsideListTile
                        : Colors.white,
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
                        ? Icon(
                            CupertinoIcons.check_mark,
                            color: isDarkMode(context)
                                ? Colors.white
                                : darkModeBlack,
                          )
                        : null,
                  ),
                  CupertinoListTile(
                    backgroundColor: isDarkMode(context)
                        ? cupertinoInsideListTile
                        : Colors.white,
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
                        ? Icon(
                            CupertinoIcons.check_mark,
                            color: isDarkMode(context)
                                ? Colors.white
                                : darkModeBlack,
                          )
                        : null,
                  ),
                ],
              ),
            );
          });
        },
      );
    },
    trailing: Icon(
      Icons.chevron_right,
      color: darkModeGrey,
    ),
  );
}
