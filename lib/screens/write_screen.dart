import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _titleController = TextEditingController(
    text: "New Note",
  );

  @override
  void dispose() {
    _textEditingController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  FocusNode titleNode = FocusNode();
  FocusNode bodyNode = FocusNode();

  void createNote({required bool isUnmissable, required BuildContext context}) {
    context.read<NotesViewModel>().addNote(
        NoteModel(
          uniqueKey: UniqueKey().hashCode,
          title: _titleController.text,
          body: _textEditingController.text,
          createdDateTime: DateTime.now(),
          editedDateTime: DateTime.now(),
          isPinned: false,
          isUnmissable: isUnmissable,
        ),
        context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        appBar: AppBar(
          shadowColor: isDarkMode(context) ? darkModeBlack : Colors.white,
          surfaceTintColor: isDarkMode(context) ? darkModeBlack : Colors.white,
          backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
          title: TextField(
            onSubmitted: (val) {
              FocusScope.of(context).requestFocus(bodyNode);
            },
            focusNode: titleNode,
            cursorColor: Colors.blue,
            controller: _titleController,
            maxLines: 1,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            decoration: const InputDecoration.collapsed(hintText: 'Title'),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  HapticFeedback.lightImpact();
                }
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () =>
                            createNote(isUnmissable: true, context: context),
                        isDefaultAction: true,
                        child: const Text(
                          "Create as unmissable",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () =>
                            createNote(isUnmissable: false, context: context),
                        child: const Text(
                          "Create",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                      ),
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Done",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            focusNode: bodyNode,
            cursorColor: Colors.blue,
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            maxLines: null,
            minLines: 7,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
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
      ),
    );
  }
}
