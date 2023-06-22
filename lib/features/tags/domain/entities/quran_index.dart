class QuranIndex {
  final int surahIndex;
  final int ayaIndex;
  final String? arabicAya;
  final String? translationAya;
  final String? surahTitle;

  QuranIndex({
    required this.surahIndex,
    required this.ayaIndex,
    this.arabicAya,
    this.translationAya,
    this.surahTitle,
  });

  QuranIndex copyWith({
    int? surahIndex,
    int? ayaIndex,
    String? arabicAya,
    String? translationAya,
    String? surahTitle,
  }) {
    return QuranIndex(
      surahIndex: surahIndex ?? this.surahIndex,
      ayaIndex: ayaIndex ?? this.ayaIndex,
      arabicAya: arabicAya ?? this.arabicAya,
      translationAya: translationAya ?? this.translationAya,
      surahTitle: surahTitle ?? this.surahTitle,
    );
  }
}
