import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

Widget fontSizeListTile(
    {required BuildContext context, required double modalHeight}) {
  return CupertinoListTile(
    leading: const Icon(Icons.text_increase),
    title: Text(
      "Font size",
      style: TextStyle(
        color: isDarkMode(context) ? Colors.white : darkModeBlack,
      ),
    ),
    trailing: const CupertinoListTileChevron(),
    onTap: () {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoModalPopupSheet(
          height: modalHeight,
          child: CupertinoListSection.insetGrouped(
            header: Text(
              "Range",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isDarkMode(context) ? darkModeGrey : headerGreyColor,
              ),
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "16.0",
                  style: TextStyle(
                    fontSize: 15,
                    color: darkModeGrey,
                  ),
                ),
                Text(
                  "25.0",
                  style: TextStyle(
                    fontSize: 15,
                    color: darkModeGrey,
                  ),
                ),
              ],
            ),
            children: [
              CupertinoListTile(
                title: SizedBox(
                  width: double.maxFinite,
                  child: CupertinoSlider(
                    activeColor: Colors.red,
                    min: 16.0,
                    max: 25.0,
                    divisions: 5,
                    onChanged: (val) =>
                        context.read<FontSizeViewModel>().setFontSize(val),
                    value: context.watch<FontSizeViewModel>().fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}