import 'package:ayat_app/src/data/models/local/data_local_models.dart';

class QuranLocalData extends Equatable {
  final List<List<NQWord>> words;
  final List<NQAyat> transliterations;
  final Map<NQTranslation, List<NQAyat>> translations;
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
    translations: {},
  );

  @override
  List<Object?> get props => [
        words,
        transliterations,
        translations,
        page,
      ];
}
