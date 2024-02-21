import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

class SortNotesViewModel extends ChangeNotifier {
  SortNotes sortNotes = SortNotes.modifiedDateTime;

  void setSorting(SortNotes sort, BuildContext context) {
    sortNotes = sort;
    context.read<NotesViewModel>().sortHelper(context);
    notifyListeners();
  }
}
