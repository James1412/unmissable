import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unmissable/models/note_model.dart';

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

  void deleteNote(int uniqueKey) {
    notes.removeWhere((NoteModel note) => note.uniqueKey == uniqueKey);
    sortHelper();
    notifyListeners();
  }

  void addNote(NoteModel noteModel) {
    notes.add(noteModel);
    sortHelper();
    notifyListeners();
  }

  void togglePin(NoteModel noteModel) {
    noteModel.isPinned = !noteModel.isPinned;
    sortHelper();
    notifyListeners();
  }

  void toggleUnmissable(NoteModel noteModel) {
    noteModel.isUnmissable = !noteModel.isUnmissable;
    sortHelper();
    notifyListeners();
  }

  void updateNote(NoteModel noteModel) {
    notes.map(
      (NoteModel note) {
        if (note.uniqueKey == noteModel.uniqueKey) {
          return noteModel;
        }
      },
    );
    sortHelper();
    notifyListeners();
  }

  void sortHelper() {
    // Edited Time sort new -> old
    // New pinned -> on top
    List<NoteModel> pinnedNotes = notes
        .where((NoteModel note) => note.isPinned)
        .toList()
        .reversed
        .toList();
    List<NoteModel> unPinnedNotes =
        notes.where((NoteModel note) => !note.isPinned).toList();
    unPinnedNotes.sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
    notes = pinnedNotes + unPinnedNotes;
    notifyListeners();
  }
}
