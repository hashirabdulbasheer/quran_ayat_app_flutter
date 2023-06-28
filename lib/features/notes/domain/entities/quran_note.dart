import 'package:equatable/equatable.dart';

import '../../../../misc/enums/quran_status_enum.dart';

class QuranNote extends Equatable {
  final String? id;
  final String localId;
  final int suraIndex;
  final int ayaIndex;
  final String note;
  final int createdOn;
  final QuranStatusEnum status;

  const QuranNote({
    required this.suraIndex,
    required this.ayaIndex,
    required this.note,
    required this.localId,
    required this.createdOn,
    required this.status,
    this.id,
  });

  QuranNote copyWith({
    String? id,
    int? suraIndex,
    int? ayaIndex,
    String? note,
    QuranStatusEnum? status,
    String? localId,
    int? createdOn,
  }) {
    return QuranNote(
      suraIndex: suraIndex ?? this.suraIndex,
      ayaIndex: ayaIndex ?? this.ayaIndex,
      note: note ?? this.note,
      id: id ?? this.id,
      localId: localId ?? this.localId,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "note": note,
      "status": status.rawString(),
      "localId": localId,
      "createdOn": createdOn,
    };
  }

  @override
  String toString() {
    return 'QuranNote{id: $id, localId: $localId, suraIndex: $suraIndex, ayaIndex: $ayaIndex, note: $note, createdOn: $createdOn, status: ${status.rawString()}}';
  }

  @override
  List<Object?> get props => [
        id,
        localId,
        suraIndex,
        ayaIndex,
        note,
        createdOn,
        status,
      ];
}
