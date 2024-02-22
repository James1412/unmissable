// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortNotesAdapter extends TypeAdapter<SortNotes> {
  @override
  final int typeId = 1;

  @override
  SortNotes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortNotes.modifiedDateTime;
      case 1:
        return SortNotes.createdDateTime;
      case 2:
        return SortNotes.alphabetical;
      default:
        return SortNotes.modifiedDateTime;
    }
  }

  @override
  void write(BinaryWriter writer, SortNotes obj) {
    switch (obj) {
      case SortNotes.modifiedDateTime:
        writer.writeByte(0);
        break;
      case SortNotes.createdDateTime:
        writer.writeByte(1);
        break;
      case SortNotes.alphabetical:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
