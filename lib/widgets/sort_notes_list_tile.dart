import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/view_models/sort_notes_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

Widget sortNotesListTile(
    {required BuildContext context, required double modalHeight}) {
  return CupertinoListTile(
    leading: const Icon(Icons.sort),
    title: Text(
      "Sort notes",
      style: TextStyle(
        color: isDarkMode(context) ? Colors.white : darkModeBlack,
      ),
    ),
    trailing: const CupertinoListTileChevron(),
    onTap: () {
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
                        .setSorting(SortNotes.modifiedDateTime);
                    setState(() {});
                  },
                  title: Text(
                    "Sort by modified datetime",
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                  ),
                  trailing: sortNotes == SortNotes.modifiedDateTime
                      ? const Icon(CupertinoIcons.check_mark)
                      : null,
                ),
                CupertinoListTile(
                  onTap: () {
                    context
                        .read<SortNotesViewModel>()
                        .setSorting(SortNotes.createdDateTime);
                    setState(() {});
                  },
                  title: Text(
                    "Sort by created datetime",
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                  ),
                  trailing: sortNotes == SortNotes.createdDateTime
                      ? const Icon(CupertinoIcons.check_mark)
                      : null,
                ),
                CupertinoListTile(
                  onTap: () {
                    context
                        .read<SortNotesViewModel>()
                        .setSorting(SortNotes.alphabetical);
                    setState(() {});
                  },
                  title: Text(
                    "Sort alphabetically",
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                  ),
                  trailing: sortNotes == SortNotes.alphabetical
                      ? const Icon(CupertinoIcons.check_mark)
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
