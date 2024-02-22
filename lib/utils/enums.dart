import 'package:hive_flutter/hive_flutter.dart';

part 'enums.g.dart';

@HiveType(typeId: 1)
enum SortNotes {
  @HiveField(0)
  modifiedDateTime,
  @HiveField(1)
  createdDateTime,
  @HiveField(2)
  alphabetical,
}
