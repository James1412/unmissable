import 'package:flutter/cupertino.dart';
import 'package:unmissable/utils/enums.dart';

class SortNotesViewModel extends ChangeNotifier {
  SortNotes sortNotes = SortNotes.modifiedDateTime;

  void setSorting(SortNotes sort) {
    sortNotes = sort;
    notifyListeners();
  }
}
