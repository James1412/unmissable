import 'package:hive_flutter/hive_flutter.dart';

part 'note_model.g.dart';

@HiveType(typeId: 2)
class NoteModel {
  @HiveField(0)
  int uniqueKey;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  DateTime createdDateTime;

  @HiveField(4)
  DateTime editedDateTime;

  @HiveField(5)
  bool isPinned;

  @HiveField(6)
  bool isUnmissable;

  NoteModel({
    required this.uniqueKey,
    required this.title,
    required this.body,
    required this.createdDateTime,
    required this.editedDateTime,
    required this.isPinned,
    required this.isUnmissable,
  });
}
