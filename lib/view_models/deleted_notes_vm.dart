import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/repos/deleted_notes_repo.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class DeletedNotesViewModel extends ChangeNotifier {
  final db = DeletedNotesRepository();
  late List<NoteModel> deletedNotes = db.getNotes();

  void addNote(NoteModel note) {
    deletedNotes.add(note);
    db.addOrUpdateNote(note);
    notifyListeners();
  }

  void deleteNote(NoteModel note, BuildContext context) {
    deletedNotes.removeWhere(
        (NoteModel noteModel) => noteModel.uniqueKey == note.uniqueKey);
    db.removeNote(note);
    notifyListeners();
  }

  void recoverNote(NoteModel note, BuildContext context) {
    deleteNote(note, context);
    context.read<NotesViewModel>().addNote(note, context);
    db.removeNote(note);
    notifyListeners();
  }

  void deleteAllNotes() {
    deletedNotes.clear();
    db.removeAll();
    notifyListeners();
  }
}
