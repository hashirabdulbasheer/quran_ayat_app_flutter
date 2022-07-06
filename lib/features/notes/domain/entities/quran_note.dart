class QuranNote {
  final String? id;
  final int suraIndex;
  final int ayaIndex;
  final String note;
  final int createdOn;

  QuranNote(
      {required this.suraIndex,
      required this.ayaIndex,
      required this.note,
      required this.createdOn,
      this.id});

  QuranNote copyWith(
      {String? id,
      int? suraIndex,
      int? ayaIndex,
      String? note,
      int? createdOn}) {
    return QuranNote(
        suraIndex: suraIndex ?? this.suraIndex,
        ayaIndex: ayaIndex ?? this.ayaIndex,
        note: note ?? this.note,
        id: id ?? this.id,
        createdOn: createdOn ?? this.createdOn);
  }
}
