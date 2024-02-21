class NoteModel {
  int uniqueKey;
  String title;
  String body;
  DateTime createdDateTime;
  DateTime editedDateTime;
  bool isPinned;
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
