import 'package:noble_quran/models/word.dart';

class QuranWord {
  NQWord word;
  double similarityScore;

  QuranWord({required this.word, required this.similarityScore,});
}
