import 'package:hive_flutter/hive_flutter.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/hive_box_names.dart';

final deletedNotesBox = Hive.box<NoteModel>(deletedNotesBoxName);

class DeletedNotesRepository {
  Future<void> addOrUpdateNote(NoteModel note) async {
    await deletedNotesBox.put(note.uniqueKey, note);
  }

  Future<void> removeNote(NoteModel note) async {
    await deletedNotesBox.delete(note.uniqueKey);
  }

  List<NoteModel> getNotes() {
    return deletedNotesBox.values.toList();
  }

  void removeAll() {
    deletedNotesBox.clear();
  }
}
