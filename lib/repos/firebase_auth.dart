// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/view_models/deleted_notes_vm.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class FirebaseAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> initAuth() async {
    const Settings(persistenceEnabled: true);
    if (_auth.currentUser != null) {
      print('already signed in');
      // Get Firestore data
    }
    if (_auth.currentUser == null) {
      // Use Hive
      print("is not signed in yet. Currently using hive");
    }
  }

  Future<FirebaseAuthException?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e;
    }
    return null;
  }

  Future<FirebaseAuthException?> signUpWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // ignore: use_build_context_synchronously
      // Add the notes to firebase when sign up
      for (NoteModel note
          in Provider.of<NotesViewModel>(context, listen: false).notes) {
        await _firestore
            .collection(notesBoxName)
            .doc(note.uniqueKey.toString())
            .set(note.toJson(_auth.currentUser!.uid));
      }
      for (NoteModel note
          in Provider.of<DeletedNotesViewModel>(context, listen: false)
              .deletedNotes) {
        await _firestore
            .collection(deletedNotesBoxName)
            .doc(note.uniqueKey.toString())
            .set(note.toJson(_auth.currentUser!.uid));
      }
    } on FirebaseAuthException catch (e) {
      return e;
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Delete all data
      await _firestore
          .collection(notesBoxName)
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      await _firestore
          .collection(deletedNotesBoxName)
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      User user = _auth.currentUser!;
      await user.delete();
    } catch (e) {
      print(e);
    }
  }
}
