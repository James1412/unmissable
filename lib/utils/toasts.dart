import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unmissable/models/note_model.dart';

void showToast({
  required String message,
  required Widget icon,
  required Color color,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      duration: const Duration(milliseconds: 700),
      margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      backgroundColor: color,
      content: SizedBox(
        height: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 5,
            ),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void unmissableToast(BuildContext context, NoteModel noteModel) {
  showToast(
      message: noteModel.isUnmissable ? "Unmissable" : "missable",
      icon: Transform.translate(
        offset: const Offset(0, 2.5),
        child: Icon(
          noteModel.isUnmissable
              ? CupertinoIcons.bell_fill
              : CupertinoIcons.bell_slash_fill,
          size: 15,
          color: Colors.white,
        ),
      ),
      color: Colors.yellow.shade600,
      context: context);
}

void pinToast(BuildContext context, NoteModel noteModel) {
  showToast(
      message: !noteModel.isPinned ? "Pinned" : "Unpinned",
      icon: Transform.translate(
        offset: const Offset(0, 2.5),
        child: Icon(
          !noteModel.isPinned
              ? CupertinoIcons.pin_fill
              : CupertinoIcons.pin_slash_fill,
          size: 15,
          color: Colors.white,
        ),
      ),
      color: Colors.blue.shade600,
      context: context);
}

void deleteToast(BuildContext context, NoteModel noteModel) {
  showToast(
      message: "Deleted",
      icon: Transform.translate(
        offset: const Offset(0, 1.5),
        child: const Icon(
          Icons.delete,
          size: 15,
          color: Colors.white,
        ),
      ),
      color: Colors.red.shade600,
      context: context);
}

void recoverToast(BuildContext context, NoteModel noteModel) {
  showToast(
      message: "Recovered",
      icon: Transform.translate(
        offset: const Offset(0, 2.5),
        child: const Icon(
          Icons.restore,
          size: 15,
          color: Colors.white,
        ),
      ),
      color: Colors.greenAccent,
      context: context);
}
