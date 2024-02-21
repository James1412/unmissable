import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/enums.dart';
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

  void deleteNote(int uniqueKey, BuildContext context) {
    notes.removeWhere((NoteModel note) => note.uniqueKey == uniqueKey);
    sortHelper(context);
    notifyListeners();
  }

  void addNote(NoteModel noteModel, BuildContext context) {
    notes.add(noteModel);
    sortHelper(context);
    notifyListeners();
  }

  void togglePin(NoteModel noteModel, BuildContext context) {
    noteModel.isPinned = !noteModel.isPinned;
    sortHelper(context);
    notifyListeners();
  }

  void toggleUnmissable(NoteModel noteModel, BuildContext context) {
    noteModel.isUnmissable = !noteModel.isUnmissable;
    sortHelper(context);
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

  void sortHelper(BuildContext context) {
    SortNotes sorting =
        Provider.of<SortNotesViewModel>(context, listen: false).sortNotes;
    if (sorting == SortNotes.modifiedDateTime) {
      // Edited Time sort new -> old
      // New pinned -> on top
      List<NoteModel> pinnedNotes = notes
          .where((NoteModel note) => note.isPinned)
          .toList()
          .reversed
          .toList();
      List<NoteModel> unPinnedNotes =
          notes.where((NoteModel note) => !note.isPinned).toList();
      unPinnedNotes
          .sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    } else if (sorting == SortNotes.createdDateTime) {
      List<NoteModel> pinnedNotes = notes
          .where((NoteModel note) => note.isPinned)
          .toList()
          .reversed
          .toList();
      List<NoteModel> unPinnedNotes =
          notes.where((NoteModel note) => !note.isPinned).toList();
      unPinnedNotes
          .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    } else if (sorting == SortNotes.alphabetical) {
      List<NoteModel> pinnedNotes = notes
          .where((NoteModel note) => note.isPinned)
          .toList()
          .reversed
          .toList();
      List<NoteModel> unPinnedNotes =
          notes.where((NoteModel note) => !note.isPinned).toList();
      unPinnedNotes.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      notes = pinnedNotes + unPinnedNotes;
      notifyListeners();
    }
  }
}
