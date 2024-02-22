import 'package:hive_flutter/hive_flutter.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/utils/hive_box_names.dart';

final sortNotesBox = Hive.box(sortNotesBoxName);

class SortNotesRepository {
  Future<void> setSorting(SortNotes sort) async {
    await sortNotesBox.put(sortNotesBoxName, sort);
  }

  SortNotes getSort() {
    return sortNotesBox.get(sortNotesBoxName) ?? SortNotes.modifiedDateTime;
  }
}
