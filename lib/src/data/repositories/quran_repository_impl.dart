import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/local/quran_local_data_source.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

@LazySingleton(as: QuranRepository)
class QuranRepositoryImpl extends QuranRepository {
  QuranDataSource dataSource;

  QuranRepositoryImpl({required this.dataSource});

  // mappers
  final NQayatlistToAyalistMapper _nQayatlistToAyalistMapper =
      NQayatlistToAyalistMapper();
  final QTranslationToNQTranslationMapper _qTranslationToNQTranslationMapper =
      QTranslationToNQTranslationMapper();
  final NQTranslationToQTranslationMapper _nqTranslationToQTranslationMapper =
      NQTranslationToQTranslationMapper();
  final NQWordListListToQWordListListMapper
      _nqWordListListToQWordListListMapper =
      NQWordListListToQWordListListMapper();
  final LocalPageToQPageMapper _localPageToQPageMapper =
      LocalPageToQPageMapper();
  final NQRukuToRukuMapper _nqRukuToRukuMapper = NQRukuToRukuMapper();

  @override
  Future<QPageData> getPageQuranData({
    required int pageNo,
    required List<QTranslation> translationTypes,
  }) async {
    final response = await dataSource.getPageQuranData(
        pageNo: pageNo,
        translationTypes: translationTypes
            .map((e) => _qTranslationToNQTranslationMapper.mapFrom(e))
            .toList());

    return QPageData(
      page: _localPageToQPageMapper.mapFrom(response.page),
      ayaWords: _nqWordListListToQWordListListMapper.mapFrom(response.words),
      transliterations:
          _nQayatlistToAyalistMapper.mapFrom(response.transliterations),
      translations: response.translations.keys
          .map((e) => (
                _nqTranslationToQTranslationMapper.mapFrom(e),
                _nQayatlistToAyalistMapper
                    .mapFrom(response.translations[e] ?? [])
              ))
          .toList(),
    );
  }

  @override
  Future<List<SuraTitle>> getSuraTitles() async {
    final response = await dataSource.getSuraTitles();

    return response
        .map((e) => SuraTitle(
              number: e.number,
              name: e.name,
              transliterationEn: e.transliterationEn,
              translationEn: e.translationEn,
              totalVerses: e.totalVerses,
            ))
        .toList();
  }

  @override
  Ruku? getRuku(SurahIndex suraIndex) {
    final nqRuku = dataSource.getRuku(suraIndex.sura, suraIndex.aya);
    if (nqRuku != null) {
      return _nqRukuToRukuMapper.mapFrom(nqRuku);
    }
    return null;
  }
}
