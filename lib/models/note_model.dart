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

  NoteModel.fromJson(Map<String, dynamic> json)
      : uniqueKey = json["uniqueKey"],
        title = json['title'],
        body = json['body'],
        createdDateTime =
            DateTime.parse(json['createdDateTime'].toDate().toString()),
        editedDateTime =
            DateTime.parse(json['editedDateTime'].toDate().toString()),
        isPinned = json['isPinned'],
        isUnmissable = json['isUnmissable'];

  Map<String, dynamic> toJson(uid) {
    return {
      "uniqueKey": uniqueKey,
      "title": title,
      "body": body,
      "createdDateTime": createdDateTime,
      "editedDateTime": editedDateTime,
      "isPinned": isPinned,
      "isUnmissable": isUnmissable,
      "uid": uid,
    };
  }
}
