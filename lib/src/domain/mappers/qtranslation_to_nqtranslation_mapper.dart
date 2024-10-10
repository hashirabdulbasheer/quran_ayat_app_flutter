import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

class QTranslationToNQTranslationMapper
    implements Mapper<QTranslation, NQTranslation> {
  @override
  NQTranslation mapFrom(QTranslation from) {
    switch (from) {
      case QTranslation.sahih:
        return NQTranslation.sahih;
      case QTranslation.hilali:
        return NQTranslation.hilali;
      case QTranslation.haleem:
        return NQTranslation.haleem;
      case QTranslation.clear:
        return NQTranslation.clear;
      case QTranslation.wahiduddinKhan:
        return NQTranslation.wahiduddinkhan;
      case QTranslation.malayalamAbdulhameed:
        return NQTranslation.malayalam_abdulhameed;
      case QTranslation.malayalamKarakunnu:
        return NQTranslation.malayalam_karakunnu;
      case QTranslation.urduMaududi:
        return NQTranslation.urdu_maududi;

      default:
        return NQTranslation.wahiduddinkhan;
    }
  }
}
