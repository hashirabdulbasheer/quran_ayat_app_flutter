import 'package:ayat_app/src/data/models/local/local_sura_title.dart';
import 'package:ayat_app/src/data/models/local_page.dart';
import 'package:injectable/injectable.dart';
import 'package:noble_quran/noble_quran.dart';

import '../models/local/quran_local_data.dart';

abstract class QuranDataSource {
  Future<QuranLocalData> getPageQuranData({
    required int pageNo,
    required NQTranslation translationType,
  });

  Future<List<LocalSuraTitle>> getSuraTitles();

  NQRuku? getRuku(int sura, int aya);
}

@Injectable(as: QuranDataSource)
class QuranLocalDataSourceImpl extends QuranDataSource {
  @override
  Future<QuranLocalData> getPageQuranData({
    required int pageNo,
    required NQTranslation translationType,
  }) async {
    final localRuku = _getRuku(pageNo);
    if (localRuku == null) {
      return QuranLocalData.defaultValue;
    }

    final words = await _getWords(localRuku);
    final translations = await _getTranslations(localRuku, translationType);
    final transliterations = await _getTransliteration(localRuku);

    return QuranLocalData(
      page: LocalPage(
        pgNo: pageNo,
        firstAyaIndex: (
          sura: localRuku.startIndexSura,
          aya: localRuku.startIndexAya
        ),
        numOfAya: localRuku.numOfAyas,
      ),
      words: words,
      transliterations: transliterations,
      translations: translations,
    );
  }

  @override
  Future<List<LocalSuraTitle>> getSuraTitles() async {
    List<NQSurahTitle> nqTitles = await NobleQuran.getSurahList();

    return nqTitles
        .map((e) => LocalSuraTitle(
              number: e.number,
              name: e.name,
              transliterationEn: e.transliterationEn,
              translationEn: e.translationEn,
              totalVerses: e.totalVerses,
            ))
        .toList();
  }

  NQRuku? _getRuku(int pageNo) {
    return NobleQuran.getRuku(pageNo);
  }

  Future<List<List<NQWord>>> _getWords(NQRuku localRuku) async {
    return (await NobleQuran.getSurahWordByWord(localRuku.startIndexSura))
        .sublist(
      localRuku.startIndexAya,
      localRuku.startIndexAya + localRuku.numOfAyas,
    );
  }

  Future<List<NQAyat>> _getTranslations(
    NQRuku localRuku,
    NQTranslation translationType,
  ) async {
    return (await NobleQuran.getTranslationString(
            localRuku.startIndexSura, translationType))
        .aya
        .sublist(
          localRuku.startIndexAya,
          localRuku.startIndexAya + localRuku.numOfAyas,
        );
  }

  Future<List<NQAyat>> _getTransliteration(
    NQRuku localRuku,
  ) async {
    return (await NobleQuran.getSurahTransliteration(localRuku.startIndexSura))
        .aya
        .sublist(
          localRuku.startIndexAya,
          localRuku.startIndexAya + localRuku.numOfAyas,
        );
  }

  @override
  NQRuku? getRuku(int sura, int aya) {
    return NobleQuran.getRukuForAya(sura, aya);
  }
}
