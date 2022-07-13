// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_note_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranNoteDtoAdapter extends TypeAdapter<QuranNoteDto> {
  @override
  final int typeId = 0;

  @override
  QuranNoteDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranNoteDto(
      suraIndex: fields[1] as int,
      ayaIndex: fields[2] as int,
      note: fields[3] as String,
      createdOn: fields[4] as int,
      status: fields[5] as String,
      localId: fields[6] as String,
      id: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuranNoteDto obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.suraIndex)
      ..writeByte(2)
      ..write(obj.ayaIndex)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.createdOn)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.localId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranNoteDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
