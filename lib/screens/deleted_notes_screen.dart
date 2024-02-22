import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/screens/view_screen.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/deleted_notes_vm.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';

class DeletedNotesScreen extends StatefulWidget {
  const DeletedNotesScreen({super.key});

  @override
  State<DeletedNotesScreen> createState() => _DeletedNotesScreenState();
}

class _DeletedNotesScreenState extends State<DeletedNotesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<NoteModel> notes = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    notes = context.watch<DeletedNotesViewModel>().deletedNotes;
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        shadowColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        surfaceTintColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        foregroundColor: isDarkMode(context) ? Colors.white : darkModeBlack,
        actions: [
          GestureDetector(
            onTap: () {
              context.read<DeletedNotesViewModel>().deleteAllNotes();
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Delete all",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        controller: _scrollController,
        itemCount: notes.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 1,
            color: isDarkMode(context) ? darkModeGrey : Colors.black12,
            width: double.maxFinite,
          ),
        ),
        itemBuilder: (context, index) => Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  if (Platform.isIOS) {
                    HapticFeedback.lightImpact();
                  }
                  context
                      .read<DeletedNotesViewModel>()
                      .recoverNote(notes[index], context);
                },
                backgroundColor: Colors.greenAccent,
                icon: Icons.restore,
              ),
              SlidableAction(
                onPressed: (context) {
                  if (Platform.isIOS) {
                    HapticFeedback.lightImpact();
                  }
                  context
                      .read<DeletedNotesViewModel>()
                      .deleteNote(notes[index], context);
                },
                backgroundColor: Colors.red,
                icon: FontAwesomeIcons.trash,
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (Platform.isIOS) {
                HapticFeedback.lightImpact();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewScreen(
                    note: notes[index],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoListTile(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 5,
                ),
                title: Text(
                  notes[index].title,
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  notes[index].body.replaceAll('\n', ''),
                  style: TextStyle(
                    color: darkModeGrey,
                    fontSize: fontSize - 3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
