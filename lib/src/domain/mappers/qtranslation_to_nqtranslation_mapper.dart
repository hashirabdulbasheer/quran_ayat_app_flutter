import 'package:ayat_app/src/core/mapper/mapper.dart';
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:noble_quran/noble_quran.dart';

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
