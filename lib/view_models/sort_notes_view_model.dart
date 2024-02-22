import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/repos/sort_notes_repo.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class SortNotesViewModel extends ChangeNotifier {
  final db = SortNotesRepository();
  late SortNotes sortNotes = db.getSort() == SortNotes.alphabetical.toString()
      ? SortNotes.alphabetical
      : db.getSort() == SortNotes.createdDateTime.toString()
          ? SortNotes.createdDateTime
          : SortNotes.modifiedDateTime;

  void setSorting(SortNotes sort, BuildContext context) {
    sortNotes = sort;
    db.setSorting(sort);
    context.read<NotesViewModel>().sortHelper(context);
    notifyListeners();
  }
}
