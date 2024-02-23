// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/repos/notes_repository.dart';
import 'package:unmissable/services/notification_service.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/utils/toasts.dart';
import 'package:unmissable/view_models/deleted_notes_vm.dart';
import 'package:unmissable/view_models/notification_interval_vm.dart';
import 'package:unmissable/view_models/sort_notes_view_model.dart';

class NotesViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final hiveDB = HiveNoteRepository();
  late List<NoteModel> notes = hiveDB.getNotes(context);

  BuildContext context;
  NotesViewModel({required this.context});

  Future<void> deleteNote(NoteModel noteModel, BuildContext context) async {
    deleteToast(context);
    notes
        .removeWhere((NoteModel note) => note.uniqueKey == noteModel.uniqueKey);
    sortHelper(context);
    if (noteModel.isUnmissable) {
      await NotificationService()
          .cancelScheduledNotification(noteModel.uniqueKey);
    }
    context.read<DeletedNotesViewModel>().addNote(noteModel);
    if (_auth.currentUser == null) {
      hiveDB.removeNote(noteModel);
    } else {
      await _firestore
          .collection(notesBoxName)
          .doc(noteModel.uniqueKey.toString())
          .delete();
    }
    notifyListeners();
  }

  Future<void> addNote(NoteModel noteModel, BuildContext context) async {
    notes.add(noteModel);
    sortHelper(context);
    if (noteModel.isUnmissable) {
      await notificationOnHelper(context);
    }
    if (_auth.currentUser == null) {
      hiveDB.addOrUpdateNote(noteModel);
    } else {
      await _firestore
          .collection(notesBoxName)
          .doc(noteModel.uniqueKey.toString())
          .set(noteModel.toJson(_auth.currentUser!.uid));
    }
    notifyListeners();
  }

  Future<void> togglePin(NoteModel noteModel, BuildContext context) async {
    pinToast(context, noteModel);
    noteModel.isPinned = !noteModel.isPinned;
    sortHelper(context);
    if (_auth.currentUser == null) {
      hiveDB.addOrUpdateNote(noteModel);
    } else {
      await _firestore
          .collection(notesBoxName)
          .doc(noteModel.uniqueKey.toString())
          .set(noteModel.toJson(_auth.currentUser!.uid));
    }
    notifyListeners();
  }

  Future<void> toggleUnmissable(
      NoteModel noteModel, BuildContext context) async {
    noteModel.isUnmissable = !noteModel.isUnmissable;
    unmissableToast(context, noteModel);
    sortHelper(context);
    if (noteModel.isUnmissable) {
      // When unmissable
      await notificationOnHelper(context);
    } else if (!noteModel.isUnmissable) {
      // When cancelled unmissable
      await NotificationService()
          .cancelScheduledNotification(noteModel.uniqueKey);
    }
    if (_auth.currentUser == null) {
      hiveDB.addOrUpdateNote(noteModel);
    } else {
      await _firestore
          .collection(notesBoxName)
          .doc(noteModel.uniqueKey.toString())
          .set(noteModel.toJson(_auth.currentUser!.uid));
    }
    notifyListeners();
  }

  Future<void> updateNote(NoteModel noteModel, BuildContext context) async {
    notes.map(
      (NoteModel note) {
        if (note.uniqueKey == noteModel.uniqueKey) {
          return noteModel;
        }
      },
    );
    notificationOnHelper(context);
    sortHelper(context);
    if (_auth.currentUser == null) {
      hiveDB.addOrUpdateNote(noteModel);
    } else {
      await _firestore
          .collection(notesBoxName)
          .doc(noteModel.uniqueKey.toString())
          .set(noteModel.toJson(_auth.currentUser!.uid));
    }
    notifyListeners();
  }

  Future<void> notificationOnHelper(BuildContext context) async {
    RepeatInterval interval =
        Provider.of<NotificationIntervalViewModel>(context, listen: false)
            .interval;
    sortHelper(context);
    for (NoteModel noteModel in notes.reversed) {
      if (noteModel.isUnmissable) {
        await NotificationService().showNotification(
          title: noteModel.title,
          body: noteModel.body,
          id: noteModel.uniqueKey,
        );
        await NotificationService().repeatNotification(
          title: noteModel.title,
          body: noteModel.body,
          id: noteModel.uniqueKey,
          repeatInterval: interval,
        );
      }
    }
  }

  Future<void> notificationAllOff() async {
    await NotificationService().cancelAllNotification();
    notes = notes.map((NoteModel note) => note..isUnmissable = false).toList();
    for (NoteModel note in notes) {
      if (_auth.currentUser == null) {
        hiveDB.addOrUpdateNote(note);
      } else {
        await _firestore
            .collection(notesBoxName)
            .doc(note.uniqueKey.toString())
            .set(note.toJson(_auth.currentUser!.uid));
      }
    }
    notifyListeners();
  }

  void sortHelper(BuildContext context) {
    SortNotes sorting =
        Provider.of<SortNotesViewModel>(context, listen: false).sortNotes;
    List<NoteModel> pinnedNotes =
        notes.where((NoteModel note) => note.isPinned).toList();
    List<NoteModel> unPinnedNotes =
        notes.where((NoteModel note) => !note.isPinned).toList();
    if (sorting == SortNotes.modifiedDateTime) {
      // Edited Time sort new -> old
      // New pinned -> on top
      unPinnedNotes
          .sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
      pinnedNotes.sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    } else if (sorting == SortNotes.createdDateTime) {
      unPinnedNotes
          .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
      pinnedNotes
          .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));

      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    } else if (sorting == SortNotes.alphabetical) {
      unPinnedNotes.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      pinnedNotes.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    }
  }
}

List<NoteModel> sortNotes(BuildContext context, List<NoteModel> notes) {
  late List<NoteModel> returnNotes;
  SortNotes sorting =
      Provider.of<SortNotesViewModel>(context, listen: false).sortNotes;
  List<NoteModel> pinnedNotes =
      notes.where((NoteModel note) => note.isPinned).toList();
  List<NoteModel> unPinnedNotes =
      notes.where((NoteModel note) => !note.isPinned).toList();
  if (sorting == SortNotes.modifiedDateTime) {
    // Edited Time sort new -> old
    // New pinned -> on top
    unPinnedNotes.sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
    pinnedNotes.sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
    returnNotes = pinnedNotes + unPinnedNotes;
  } else if (sorting == SortNotes.createdDateTime) {
    unPinnedNotes
        .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
    pinnedNotes.sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));

    returnNotes = pinnedNotes + unPinnedNotes;
  } else if (sorting == SortNotes.alphabetical) {
    unPinnedNotes
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    pinnedNotes
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    returnNotes = pinnedNotes + unPinnedNotes;
  }
  return returnNotes;
}
