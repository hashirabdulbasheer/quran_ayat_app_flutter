import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/ruku.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';

abstract class QuranRepository {
  Future<QPageData> getPageQuranData({
    required int pageNo,
    required QTranslation translationType,
  });

  Future<List<SuraTitle>> getSuraTitles();

  Ruku? getRuku(SurahIndex suraIndex);
}
