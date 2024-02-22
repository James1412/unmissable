import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/view_models/sort_notes_view_model.dart';

final noteBox = Hive.box<NoteModel>(notesBoxName);

class NoteRepository {
  Future<void> addOrUpdateNote(NoteModel note) async {
    await noteBox.put(note.uniqueKey, note);
  }

  Future<void> removeNote(NoteModel note) async {
    await noteBox.delete(note.uniqueKey);
  }

  List<NoteModel> getNotes(BuildContext context) {
    List<NoteModel> notes = noteBox.values.toList();
    // Sort when gets the notes
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
      unPinnedNotes
          .sort((a, b) => b.editedDateTime.compareTo(a.editedDateTime));
      notes = pinnedNotes + unPinnedNotes;
    } else if (sorting == SortNotes.createdDateTime) {
      unPinnedNotes
          .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
      notes = pinnedNotes + unPinnedNotes;
    } else if (sorting == SortNotes.alphabetical) {
      unPinnedNotes.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      notes = pinnedNotes + unPinnedNotes;
    }
    return notes;
  }

  void removeAll() {
    noteBox.clear();
  }
}
