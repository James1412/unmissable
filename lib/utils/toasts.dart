import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unmissable/models/note_model.dart';

void showToast({
  required String message,
  required IconData icon,
  required Color color,
  required FToast fToast,
}) {
  fToast.showToast(
    toastDuration: const Duration(seconds: 1),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    ),
  );
}

void pinToast({required FToast fToast, required NoteModel note}) {
  showToast(
    message: note.isPinned ? "Pinned" : "Unpinned",
    icon: Icons.check,
    color: Colors.greenAccent,
    fToast: fToast,
  );
}

void deleteToast({required FToast fToast, required NoteModel note}) {
  showToast(
    message: "Deleted",
    icon: Icons.delete,
    color: Colors.redAccent,
    fToast: fToast,
  );
}

void unmissableToast({required FToast fToast, required NoteModel note}) {
  showToast(
      message: note.isUnmissable ? "Unmissable" : "Notification off",
      icon: CupertinoIcons.bell,
      color: Colors.amberAccent,
      fToast: fToast);
}
