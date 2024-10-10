import 'package:ayat_app/src/domain/models/domain_models.dart';

abstract class QuranRepository {
  Future<QPageData> getPageQuranData({
    required int pageNo,
    required QTranslation translationType,
  });

  Future<List<SuraTitle>> getSuraTitles();

  Ruku? getRuku(SurahIndex suraIndex);
}
