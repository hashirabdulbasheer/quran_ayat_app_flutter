import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';

class NQTranslationToQTranslationMapper
    implements Mapper<NQTranslation, QTranslation> {
  @override
  QTranslation mapFrom(NQTranslation from) {
    switch (from) {
      case NQTranslation.sahih:
        return QTranslation.sahih;
      case NQTranslation.hilali:
        return QTranslation.hilali;
      case NQTranslation.haleem:
        return QTranslation.haleem;
      case NQTranslation.clear:
        return QTranslation.clear;
      case NQTranslation.wahiduddinkhan:
        return QTranslation.wahiduddinKhan;
      case NQTranslation.malayalam_abdulhameed:
        return QTranslation.malayalamAbdulhameed;
      case NQTranslation.malayalam_karakunnu:
        return QTranslation.malayalamKarakunnu;
      case NQTranslation.urdu_maududi:
        return QTranslation.urduMaududi;

      default:
        return QTranslation.wahiduddinKhan;
    }
  }
}
