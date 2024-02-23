import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/repos/deleted_notes_repo.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class DeletedNotesViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final hiveDB = DeletedNotesRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<NoteModel> deletedNotes = hiveDB.getNotes();

  Future<void> addNote(NoteModel note) async {
    deletedNotes.add(note);

    if (_auth.currentUser == null) {
      hiveDB.addOrUpdateNote(note);
    } else {
      await _firestore
          .collection(deletedNotesBoxName)
          .doc(note.uniqueKey.toString())
          .set(note.toJson(_auth.currentUser!.uid));
    }
    notifyListeners();
  }

  Future<void> deleteNote(NoteModel note, BuildContext context) async {
    deletedNotes.removeWhere(
        (NoteModel noteModel) => noteModel.uniqueKey == note.uniqueKey);
    if (_auth.currentUser == null) {
      hiveDB.removeNote(note);
    } else {
      await _firestore
          .collection(deletedNotesBoxName)
          .doc(note.uniqueKey.toString())
          .delete();
    }
    notifyListeners();
  }

  Future<void> recoverNote(NoteModel note, BuildContext context) async {
    deleteNote(note, context);
    context.read<NotesViewModel>().addNote(note, context);
    if (_auth.currentUser == null) {
      hiveDB.removeNote(note);
    }
    {
      await _firestore
          .collection(deletedNotesBoxName)
          .doc(note.uniqueKey.toString())
          .delete();
    }
    notifyListeners();
  }

  Future<void> deleteAllNotes() async {
    deletedNotes.clear();
    if (_auth.currentUser == null) {
      hiveDB.removeAll();
    } else {
      await _firestore
          .collection(deletedNotesBoxName)
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    }
    notifyListeners();
  }
}
