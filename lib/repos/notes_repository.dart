import 'package:hive_flutter/hive_flutter.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/hive_box_names.dart';

final noteBox = Hive.box<NoteModel>(notesBoxName);

class NoteRepository {
  Future<void> addOrUpdateNote(NoteModel note) async {
    await noteBox.put(note.uniqueKey, note);
  }

  Future<void> removeNote(NoteModel note) async {
    await noteBox.delete(note.uniqueKey);
  }

  List<NoteModel> getNotes() {
    return noteBox.values.toList();
  }

  void removeAll() {
    noteBox.clear();
  }
}
