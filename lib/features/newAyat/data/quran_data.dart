import 'package:equatable/equatable.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/word.dart';

class QuranData extends Equatable {
  final List<List<NQWord>> words;
  final Map<NQTranslation, NQSurah> translationMap;
  final NQSurah? translation;
  final NQTranslation translationType;
  final NQSurah? transliteration;

  const QuranData({
    this.words = const [],
    this.translation,
    this.translationType = NQTranslation.wahiduddinkhan,
    this.translationMap = const {},
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
      translation: translation ?? this.translation,
      translationType: translationType ?? this.translationType,
      translationMap: translationMap ?? this.translationMap,
      transliteration: transliteration ?? this.transliteration,
    );
  }

  @override
  List<Object?> get props => [
        words,
        translation,
        transliteration,
        translationMap,
        translationType,
      ];
}
