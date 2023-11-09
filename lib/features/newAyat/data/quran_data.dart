import 'package:equatable/equatable.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/word.dart';

class QuranData extends Equatable {
  final List<List<NQWord>> words;
  final NQSurah? translation;

  const QuranData({
    this.words = const [],
    this.translation,
  });

  QuranData copyWith({
    List<List<NQWord>>? words,
    NQSurah? translation,
  }) {
    return QuranData(
      words: words ?? this.words,
      translation: translation ?? this.translation,
    );
  }

  @override
  List<Object?> get props => [
        words,
        translation,
      ];
}
