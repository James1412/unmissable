// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/services/notification_service.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/view_models/notification_interval_vm.dart';
import 'package:unmissable/view_models/sort_notes_view_model.dart';

class NotesViewModel extends ChangeNotifier {
  List<NoteModel> notes = [
    NoteModel(
      uniqueKey: UniqueKey().hashCode,
      title: "title1",
      body: "body1",
      createdDateTime: DateTime.now().subtract(const Duration(days: 1)),
      editedDateTime: DateTime.now().subtract(const Duration(hours: 1)),
      isPinned: true,
      isUnmissable: false,
    ),
    NoteModel(
      uniqueKey: UniqueKey().hashCode,
      title: "title2",
      body: "body2",
      createdDateTime: DateTime.now().subtract(const Duration(days: 3)),
      editedDateTime: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: false,
      isUnmissable: false,
    ),
    NoteModel(
      uniqueKey: UniqueKey().hashCode,
      title: "title3",
      body: "body3",
      createdDateTime: DateTime.now().subtract(const Duration(days: 10)),
      editedDateTime: DateTime.now().subtract(const Duration(hours: 3)),
      isPinned: false,
      isUnmissable: false,
    ),
  ];

  Future<void> deleteNote(NoteModel noteModel, BuildContext context) async {
    notes
        .removeWhere((NoteModel note) => note.uniqueKey == noteModel.uniqueKey);
    sortHelper(context);
    if (noteModel.isUnmissable) {
      await NotificationService()
          .cancelScheduledNotification(noteModel.uniqueKey);
    }
    notifyListeners();
  }

  Future<void> addNote(NoteModel noteModel, BuildContext context) async {
    notes.add(noteModel);
    sortHelper(context);
    if (noteModel.isUnmissable) {
      await notificationOnHelper(context);
    }
    notifyListeners();
  }

  void togglePin(NoteModel noteModel, BuildContext context) {
    noteModel.isPinned = !noteModel.isPinned;
    sortHelper(context);
    notifyListeners();
  }

  Future<void> toggleUnmissable(
      NoteModel noteModel, BuildContext context) async {
    noteModel.isUnmissable = !noteModel.isUnmissable;
    sortHelper(context);
    if (noteModel.isUnmissable) {
      // When unmissable
      await notificationOnHelper(context);
    } else if (!noteModel.isUnmissable) {
      // When cancelled unmissable
      await NotificationService()
          .cancelScheduledNotification(noteModel.uniqueKey);
    }
    notifyListeners();
  }

  void updateNote(NoteModel noteModel, BuildContext context) {
    notes.map(
      (NoteModel note) {
        if (note.uniqueKey == noteModel.uniqueKey) {
          return noteModel;
        }
      },
    );
    sortHelper(context);
    notifyListeners();
  }

  Future<void> notificationOnHelper(BuildContext context) async {
    RepeatInterval interval =
        Provider.of<NotificationIntervalViewModel>(context, listen: false)
            .interval;
    for (NoteModel noteModel in notes) {
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
    notifyListeners();
  }

  void sortHelper(BuildContext context) {
    SortNotes sorting =
        Provider.of<SortNotesViewModel>(context, listen: false).sortNotes;
    List<NoteModel> pinnedNotes = notes
        .where((NoteModel note) => note.isPinned)
        .toList()
        .reversed
        .toList();
    List<NoteModel> unPinnedNotes =
        notes.where((NoteModel note) => !note.isPinned).toList();
    if (sorting == SortNotes.modifiedDateTime) {
      // Edited Time sort new -> old
      // New pinned -> on top
      unPinnedNotes
          .sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    } else if (sorting == SortNotes.createdDateTime) {
      unPinnedNotes
          .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    } else if (sorting == SortNotes.alphabetical) {
      unPinnedNotes.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    }
  }
}
