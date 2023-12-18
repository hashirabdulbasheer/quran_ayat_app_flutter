import 'package:equatable/equatable.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/word.dart';

class QuranData extends Equatable {
  final List<List<NQWord>> words;
  final Map<NQTranslation, NQSurah?> translationMap;
  final NQSurah? transliteration;

  const QuranData({
    this.words = const [],
    this.translationMap = const {NQTranslation.wahiduddinkhan: null},
    this.transliteration,
  });

  QuranData copyWith({
    List<List<NQWord>>? words,
    NQSurah? translation,
    NQTranslation? translationType,
    Map<NQTranslation, NQSurah>? translationMap,
    NQSurah? transliteration,
  }) {
    return QuranData(
      words: words ?? this.words,
      translationMap: translationMap ?? this.translationMap,
      transliteration: transliteration ?? this.transliteration,
    );
  }

  NQSurah? firstTranslation() {
    if (translationMap.values.isNotEmpty) {
      return translationMap.values.first;
    }

    // default
    return null;
  }

  @override
  List<Object?> get props => [
        words,
        transliteration,
        translationMap,
      ];
}
