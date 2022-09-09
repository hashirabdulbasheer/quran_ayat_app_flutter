import 'package:hive_flutter/hive_flutter.dart';

part 'quran_note_dto.g.dart';

@HiveType(typeId: 0)
class QuranNoteDto {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final int suraIndex;

  @HiveField(2)
  final int ayaIndex;

  @HiveField(3)
  final String note;

  @HiveField(4)
  final int createdOn;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final String localId;

  QuranNoteDto({
    required this.suraIndex,
    required this.ayaIndex,
    required this.note,
    required this.createdOn,
    required this.status,
    required this.localId,
    this.id,
  });

  QuranNoteDto copyWith({
    String? id,
    int? suraIndex,
    int? ayaIndex,
    String? note,
    String? status,
    String? localId,
    int? createdOn,
  }) {
    return QuranNoteDto(
      suraIndex: suraIndex ?? this.suraIndex,
      ayaIndex: ayaIndex ?? this.ayaIndex,
      note: note ?? this.note,
      id: id ?? this.id,
      status: status ?? this.status,
      localId: localId ?? this.localId,
      createdOn: createdOn ?? this.createdOn,
    );
  }
}
