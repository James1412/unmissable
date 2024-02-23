import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/sort_notes_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

Widget sortNotesListTile(
    {required BuildContext context, required double modalHeight}) {
  return CupertinoListTile(
    leading: Icon(
      Icons.sort,
      color: isDarkMode(context) ? Colors.white : darkModeBlack,
    ),
    title: Text(
      "Sort notes",
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
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          SortNotes sortNotes =
              Provider.of<SortNotesViewModel>(context, listen: false).sortNotes;
          return CupertinoModalPopupSheet(
            height: modalHeight,
            child: CupertinoListSection.insetGrouped(
              additionalDividerMargin: 0.0,
              dividerMargin: 0.0,
              children: [
                CupertinoListTile(
                  onTap: () {
                    context
                        .read<SortNotesViewModel>()
                        .setSorting(SortNotes.modifiedDateTime, context);
                    setState(() {});
                  },
                  title: Text(
                    "Sort by modified datetime",
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                  ),
                  trailing: sortNotes == SortNotes.modifiedDateTime
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
                        .read<SortNotesViewModel>()
                        .setSorting(SortNotes.createdDateTime, context);
                    setState(() {});
                  },
                  title: Text(
                    "Sort by created datetime",
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                  ),
                  trailing: sortNotes == SortNotes.createdDateTime
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
                        .read<SortNotesViewModel>()
                        .setSorting(SortNotes.alphabetical, context);
                    setState(() {});
                  },
                  title: Text(
                    "Sort alphabetically",
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                  ),
                  trailing: sortNotes == SortNotes.alphabetical
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
        }),
      );
    },
  );
}
