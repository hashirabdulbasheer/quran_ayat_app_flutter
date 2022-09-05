import '../../../../misc/enums/quran_status_enum.dart';

class QuranNote {
  final String? id;
  final String localId;
  final int suraIndex;
  final int ayaIndex;
  final String note;
  final int createdOn;
  final QuranStatusEnum status;

  QuranNote(
      {required this.suraIndex,
      required this.ayaIndex,
      required this.note,
      required this.localId,
      required this.createdOn,
      required this.status,
      this.id,});

  QuranNote copyWith(
      {String? id,
      int? suraIndex,
      int? ayaIndex,
      String? note,
      QuranStatusEnum? status,
      String? localId,
      int? createdOn,}) {
    return QuranNote(
        suraIndex: suraIndex ?? this.suraIndex,
        ayaIndex: ayaIndex ?? this.ayaIndex,
        note: note ?? this.note,
        id: id ?? this.id,
        localId: localId ?? this.localId,
        status: status ?? this.status,
        createdOn: createdOn ?? this.createdOn,);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "note": note,
      "status": status.rawString(),
      "localId": localId,
      "createdOn": createdOn,
    };
  }
}
