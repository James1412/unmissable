import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/deleted_notes_vm.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

class ViewScreen extends StatefulWidget {
  final NoteModel note;
  final Function onDeleteNote;
  const ViewScreen({super.key, required this.note, required this.onDeleteNote});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.note.title);
  late final TextEditingController _textEditingController =
      TextEditingController(text: widget.note.body);

  @override
  void dispose() {
    _textEditingController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void onInfoTap() {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoModalPopupSheet(
        height: MediaQuery.of(context).size.height * 0.35,
        child: CupertinoListSection.insetGrouped(
          additionalDividerMargin: 0.0,
          dividerMargin: 0.0,
          children: [
            CupertinoListTile(
              title: Text(
                "Created",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(widget.note.createdDateTime),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
            CupertinoListTile(
              title: Text(
                "Modified",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(widget.note.editedDateTime),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
            CupertinoListTile(
              title: Text(
                "Characters",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  _textEditingController.text.length.toString(),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
            CupertinoListTile(
              title: Text(
                "Words",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  _textEditingController.text.split(' ').length.toString(),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        shadowColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        surfaceTintColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        foregroundColor: isDarkMode(context) ? Colors.white : darkModeBlack,
        actions: [
          CupertinoButton(
            onPressed: onInfoTap,
            child: Icon(
              Icons.info_outline,
              color: isDarkMode(context) ? darkModeGrey : Colors.black,
            ),
          ),
          PullDownButton(
            itemBuilder: (_) => [
              PullDownMenuItem(
                title: 'Recover',
                icon: Icons.restore,
                onTap: () {
                  if (Platform.isIOS) {
                    HapticFeedback.lightImpact();
                  }
                  context
                      .read<DeletedNotesViewModel>()
                      .recoverNote(widget.note, context);
                  Navigator.pop(context);
                },
              ),
              PullDownMenuItem(
                isDestructive: true,
                title: 'Delete',
                icon: CupertinoIcons.trash,
                onTap: () async {
                  await widget.onDeleteNote(widget.note);
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
            buttonBuilder: (_, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: const EdgeInsets.all(15),
              child: Icon(
                CupertinoIcons.ellipsis_circle,
                color: isDarkMode(context) ? darkModeGrey : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              cursorColor: Colors.blue,
              controller: _titleController,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: isDarkMode(context) ? Colors.white : darkModeBlack,
              ),
              decoration: const InputDecoration.collapsed(hintText: 'Title'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                readOnly: true,
                cursorColor: Colors.blue,
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                maxLines: null,
                minLines: 7,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: '',
                  hintStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
