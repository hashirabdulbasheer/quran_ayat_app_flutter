import 'package:ayat_app/src/data/models/local_page.dart';
import 'package:equatable/equatable.dart';
import 'package:noble_quran/noble_quran.dart';

class QuranLocalData extends Equatable {
  final List<List<NQWord>> words;
  final List<NQAyat> transliterations;
  final List<NQAyat> translations;
  final LocalPage page;

  const QuranLocalData({
    required this.words,
    required this.transliterations,
    required this.translations,
    required this.page,
  });

  static QuranLocalData defaultValue = const QuranLocalData(
    page: LocalPage(
      pgNo: 0,
      firstAyaIndex: (sura: 0, aya: 0),
      numOfAya: 0,
    ),
    words: [],
    transliterations: [],
    translations: [],
  );

  @override
  List<Object?> get props => [
        words,
        transliterations,
        translations,
        page,
      ];
}
