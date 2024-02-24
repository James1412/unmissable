import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

class EditScreen extends StatefulWidget {
  final NoteModel note;
  final Function isSearchFalse;
  const EditScreen({
    super.key,
    required this.note,
    required this.isSearchFalse,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.note.title);
  late final TextEditingController _textEditingController =
      TextEditingController(text: widget.note.body);
  bool isUpdateNote = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void onPop() {
    if (isUpdateNote == true) {
      context.read<NotesViewModel>().updateNote(
            widget.note
              ..title = _titleController.text
              ..body = _textEditingController.text
              ..editedDateTime = DateTime.now(),
            context,
          );
    }
    widget.isSearchFalse();
  }

  void onInfoTap() {
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

  void onDelete() {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    context.read<NotesViewModel>().deleteNote(widget.note, context);
    Navigator.pop(context);
  }

  FocusNode titleNode = FocusNode();
  FocusNode bodyNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    return PopScope(
      onPopInvoked: (val) => onPop(),
      child: GestureDetector(
        onTap: () {
          if (FocusManager.instance.primaryFocus != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy >= 10) {
            if (FocusManager.instance.primaryFocus != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            actions: [
              CupertinoButton(
                onPressed: onInfoTap,
                child: Icon(
                  Icons.info_outline,
                  color: isDarkMode(context) ? darkModeGrey : Colors.black,
                ),
              ),
              PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    title: 'Pin',
                    icon: widget.note.isPinned
                        ? CupertinoIcons.pin_fill
                        : CupertinoIcons.pin,
                    onTap: () {
                      if (Platform.isIOS) {
                        HapticFeedback.lightImpact();
                      }
                      context.read<NotesViewModel>().updateNote(
                            widget.note
                              ..title = _titleController.text
                              ..body = _textEditingController.text
                              ..editedDateTime = widget.note.editedDateTime,
                            context,
                          );
                      context
                          .read<NotesViewModel>()
                          .togglePin(widget.note, context);
                    },
                  ),
                  PullDownMenuItem(
                    title: 'Unmissable',
                    icon: widget.note.isUnmissable
                        ? CupertinoIcons.bell_fill
                        : CupertinoIcons.bell,
                    onTap: () {
                      if (Platform.isIOS) {
                        HapticFeedback.lightImpact();
                      }
                      context.read<NotesViewModel>().updateNote(
                            widget.note
                              ..title = _titleController.text
                              ..body = _textEditingController.text
                              ..editedDateTime = widget.note.editedDateTime,
                            context,
                          );
                      context
                          .read<NotesViewModel>()
                          .toggleUnmissable(widget.note, context);
                    },
                  ),
                  PullDownMenuItem(
                    isDestructive: true,
                    title: 'Delete',
                    icon: CupertinoIcons.trash,
                    onTap: onDelete,
                  ),
                ],
                buttonBuilder: (context, showMenu) => CupertinoButton(
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
                  focusNode: titleNode,
                  cursorColor: Colors.blue,
                  controller: _titleController,
                  onChanged: (value) => isUpdateNote = true,
                  onSubmitted: (val) {
                    FocusScope.of(context).requestFocus(bodyNode);
                  },
                  style: TextStyle(
                    fontSize: fontSize + 10,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Title'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    focusNode: bodyNode,
                    cursorColor: Colors.blue,
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) => isUpdateNote = true,
                    autofocus: true,
                    maxLines: null,
                    minLines: 10,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Start typing your note here...',
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
        ),
      ),
    );
  }
}
