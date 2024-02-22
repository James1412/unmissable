import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class DeletedNotesViewModel extends ChangeNotifier {
  List<NoteModel> deletedNotes = [];

  void addNote(NoteModel note) {
    deletedNotes.add(note);
    notifyListeners();
  }

  void deleteNote(NoteModel note) {
    deletedNotes.removeWhere(
        (NoteModel noteModel) => noteModel.uniqueKey == note.uniqueKey);
    notifyListeners();
  }

  void recoverNote(NoteModel note, BuildContext context) {
    deleteNote(note);
    context.read<NotesViewModel>().addNote(note, context);
    notifyListeners();
  }
}
