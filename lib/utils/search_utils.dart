import 'dart:isolate';
import 'package:noble_quran/models/word.dart';
import 'package:string_similarity/string_similarity.dart';
import '../models/qr_word_model.dart';
import 'utils.dart';

class QuranSearch {

  /// All quran words
  static List<NQWord> globalQRWords = [];

  ///
  /// Global methods for search
  ///

  /// the search function for mobile that receives the arguments as a list
  /// to be run on a separate isolate
  static void searchBackgroundForDevice(List<dynamic> args) {
    // get the parameters
    SendPort responsePort = args.first as SendPort;
    String enteredText = args[1] as String;
    List<NQWord> qrWords = args[2] as List<NQWord>;
    // perform search
    List<QuranWord> results = searchStep2(enteredText, allWords: qrWords,);
    Isolate.exit(responsePort, results,);
  }

  /// search part 2 - the actual search
  static List<QuranWord> searchStep2(String enteredText, {List<NQWord>? allWords,}) {
    List<NQWord> quranWords = allWords ?? QuranSearch.globalQRWords;
    List<QuranWord> results = [];
    bool isArabic = QuranUtils.isArabic(enteredText);
    for (NQWord word in quranWords) {
      double score = 0.0;
      if(isArabic) {
        String normalizedWord = QuranUtils.normalise(word.ar);
        String normalizedEntered = QuranUtils.normalise(enteredText);
        score = normalizedWord.similarityTo(normalizedEntered);
      } else {
        score = word.tr.similarityTo(enteredText);
      }
      if (score > 0.5) {
        results.add(QuranWord(word: word, similarityScore: score,));
      }
    }

    /// NOT REMOVING DUPLICATES. THE SAME WORD MIGHT BE USED IN TWO DIFF PLACES
    /// IN DIFF CONTEXT. SO ITS SAFER TO NOT REMOVE DUPLICATES.
    /// COMMENTING FOR NOW.

    // results = QuranUtils.removeDuplicates(results);

    results.sort((QuranWord a, QuranWord b,) => b.similarityScore.compareTo(a.similarityScore));

    return results;
  }
}
