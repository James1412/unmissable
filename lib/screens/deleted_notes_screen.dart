import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/screens/view_screen.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/deleted_notes_vm.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

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

  Future<void> onDeleteNote(NoteModel note) async {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Delete the note?"),
        content: const Text("This will permanently delete the note"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("No"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Yes"),
            onPressed: () {
              context.read<DeletedNotesViewModel>().deleteNote(note, context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    notes = context.watch<DeletedNotesViewModel>().deletedNotes;
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        shadowColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        surfaceTintColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        foregroundColor: isDarkMode(context) ? Colors.white : darkModeBlack,
        actions: [
          GestureDetector(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Delete all notes?"),
                  content: const Text("This will permanently delete the notes"),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                      onPressed: () {
                        context.read<DeletedNotesViewModel>().deleteAllNotes();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
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
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              notes = context.watch<DeletedNotesViewModel>().deletedNotes;
            }
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(deletedNotesBoxName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      FirebaseAuth.instance.currentUser != null) {
                    List<NoteModel> streamNotes = [];
                    snapshot.data!.docs
                        .where((element) =>
                            element['uid'] ==
                            FirebaseAuth.instance.currentUser!.uid)
                        .forEach((element) {
                      NoteModel note = NoteModel.fromJson(element.data());
                      streamNotes.add(note);
                    });
                    notes = sortNotes(context, streamNotes);
                  } else {
                    notes = context.watch<DeletedNotesViewModel>().deletedNotes;
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: notes.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 1,
                        color:
                            isDarkMode(context) ? darkModeGrey : Colors.black12,
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
                            onPressed: (context) => onDeleteNote(notes[index]),
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
                                onDeleteNote: onDeleteNote,
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
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : darkModeBlack,
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
                  );
                });
          }),
    );
  }
}
