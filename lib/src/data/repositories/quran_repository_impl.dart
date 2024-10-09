import 'package:ayat_app/src/data/local/quran_local_data_source.dart';
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/mappers/localpage_to_page_mapper.dart';
import 'package:ayat_app/src/domain/mappers/localruku_to_ruku_mapper.dart';
import 'package:ayat_app/src/domain/mappers/nqayatlist_to_ayalist_mapper.dart';
import 'package:ayat_app/src/domain/mappers/nqwordlistlist_to_qwordlistlist_mapper.dart';
import 'package:ayat_app/src/domain/mappers/qtranslation_to_nqtranslation_mapper.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/ruku.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/repositories/quran_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: QuranRepository)
class QuranRepositoryImpl extends QuranRepository {
  QuranDataSource dataSource;

  QuranRepositoryImpl({required this.dataSource});

  // mappers
  final NQayatlistToAyalistMapper _nQayatlistToAyalistMapper =
      NQayatlistToAyalistMapper();
  final QTranslationToNQTranslationMapper _qTranslationToNQTranslationMapper =
      QTranslationToNQTranslationMapper();
  final NQWordListListToQWordListListMapper
      _nqWordListListToQWordListListMapper =
      NQWordListListToQWordListListMapper();
  final LocalPageToQPageMapper _localPageToQPageMapper =
      LocalPageToQPageMapper();
  final NQRukuToRukuMapper _nqRukuToRukuMapper = NQRukuToRukuMapper();

  @override
  Future<QPageData> getPageQuranData({
    required int pageNo,
    required QTranslation translationType,
  }) async {
    final response = await dataSource.getPageQuranData(
      pageNo: pageNo,
      translationType:
          _qTranslationToNQTranslationMapper.mapFrom(translationType),
    );

    return QPageData(
      page: _localPageToQPageMapper.mapFrom(response.page),
      ayaWords: _nqWordListListToQWordListListMapper.mapFrom(response.words),
      transliterations:
          _nQayatlistToAyalistMapper.mapFrom(response.transliterations),
      translations: [
        (
          QTranslation.wahiduddinKhan,
          _nQayatlistToAyalistMapper.mapFrom(response.translations)
        )
      ],
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
