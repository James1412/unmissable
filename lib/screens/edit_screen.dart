import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/screens/navigation_screen.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

class EditScreen extends StatefulWidget {
  final NoteModel note;
  const EditScreen({super.key, required this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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

  void onCancel() {
    _textEditingController.clear();
    _titleController.clear();
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NavigationScreen(),
      ),
    );
  }

  void onUpdate() {
    context.read<NotesViewModel>().updateNote(
          widget.note
            ..title = _titleController.text
            ..body = _textEditingController.text
            ..editedDateTime = DateTime.now(),
        );
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void onDoneTap() {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {},
            isDefaultAction: true,
            child: const Text(
              "Make it unmissable",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: onUpdate,
            child: const Text(
              "Update",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: onCancel,
            child: const Text(
              "Cancel",
            ),
          ),
        ],
      ),
    );
  }

  void onInfoTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoModalPopupSheet(
        height: MediaQuery.of(context).size.height * 0.3,
        child: CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile(
              title: const Text("Characters"),
              trailing: Material(
                  type: MaterialType.transparency,
                  child: Text(_textEditingController.text.length.toString())),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: TextField(
            cursorColor: Colors.blue,
            controller: _titleController,
            style: const TextStyle(fontSize: 25),
            decoration: const InputDecoration.collapsed(hintText: 'Title'),
          ),
          actions: [
            CupertinoButton(
              onPressed: onInfoTap,
              child: const Icon(
                Icons.info_outline,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: onDoneTap,
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Done",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            cursorColor: Colors.blue,
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            maxLines: null,
            minLines: 7,
            onChanged: (text) {
              setState(() {
                _textEditingController.text = text;
              });
            },
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
            decoration: const InputDecoration.collapsed(
              hintText: 'Start typing your note here...',
              hintStyle: TextStyle(
                fontSize: 16.0,
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
