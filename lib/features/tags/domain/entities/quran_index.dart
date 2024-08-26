import 'package:quran_ayat/features/newAyat/data/surah_index.dart';

class QuranIndex {
  final SurahIndex index;
  final String? arabicAya;
  final String? translationAya;
  final String? surahTitle;

  QuranIndex({
    required this.index,
    this.arabicAya,
    this.translationAya,
    this.surahTitle,
  });

  QuranIndex copyWith({
    SurahIndex? index,
    String? arabicAya,
    String? translationAya,
    String? surahTitle,
  }) {
    return QuranIndex(
      index: index ?? this.index,
      arabicAya: arabicAya ?? this.arabicAya,
      translationAya: translationAya ?? this.translationAya,
      surahTitle: surahTitle ?? this.surahTitle,
    );
  }
}
