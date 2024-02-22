import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/utils/is_dark_mode.dart';
import 'package:unmissable/widgets/settings_popup.dart';

class AppBarWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function onQueryChanged;
  final FocusNode focusNode;
  const AppBarWidget(
      {super.key,
      required this.textEditingController,
      required this.onQueryChanged,
      required this.focusNode});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void dispose() {
    widget.textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode(context) ? darkModeBlack : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => onMoreTap(context: context),
                  child: const Icon(FontAwesomeIcons.ellipsis),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoSearchTextField(
              focusNode: widget.focusNode,
              onChanged: (val) {
                widget.onQueryChanged();
              },
              controller: widget.textEditingController,
              backgroundColor: isDarkMode(context) ? lessdarkBlack : null,
              style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack),
              itemColor: isDarkMode(context)
                  ? Colors.white
                  : CupertinoColors.secondaryLabel,
              placeholderStyle: isDarkMode(context)
                  ? const TextStyle(color: Colors.white)
                  : null,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
