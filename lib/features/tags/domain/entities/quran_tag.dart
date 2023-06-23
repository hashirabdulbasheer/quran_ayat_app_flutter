import '../../../../misc/enums/quran_status_enum.dart';

class QuranTag {
  final String? id;
  final String localId;
  final int suraIndex;
  final int ayaIndex;
  final List<String> tag;
  final int createdOn;
  final QuranStatusEnum status;

  QuranTag({
    required this.suraIndex,
    required this.ayaIndex,
    required this.tag,
    required this.localId,
    required this.createdOn,
    required this.status,
    this.id,
  });

  QuranTag copyWith({
    String? id,
    int? suraIndex,
    int? ayaIndex,
    List<String>? tag,
    QuranStatusEnum? status,
    String? localId,
    int? createdOn,
  }) {
    return QuranTag(
      suraIndex: suraIndex ?? this.suraIndex,
      ayaIndex: ayaIndex ?? this.ayaIndex,
      tag: tag ?? this.tag,
      id: id ?? this.id,
      localId: localId ?? this.localId,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "tag": tag,
      "status": status.rawString(),
      "localId": localId,
      "createdOn": createdOn,
    };
  }
}
