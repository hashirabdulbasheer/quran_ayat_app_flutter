enum QTranslation {
  sahih,
  hilali,
  haleem,
  clear,
  wahiduddinKhan,
  malayalamAbdulhameed,
  malayalamKarakunnu,
  urduMaududi
}

extension QTranslationExtension on QTranslation {
  String get title {
    switch (this) {
      case QTranslation.sahih:
        return 'Sahih International';
      case QTranslation.hilali:
        return 'Hilali & Khan';
      case QTranslation.clear:
        return 'Clear Quran';
      case QTranslation.haleem:
        return 'Abdel Haleem';
      case QTranslation.wahiduddinKhan:
        return 'Wahiduddin Khan';
      case QTranslation.malayalamAbdulhameed:
        return 'അബ്ദുല്‍ ഹമീദ് & പറപ്പൂര്‍';
      case QTranslation.malayalamKarakunnu:
        return 'കാരകുന്ന് & എളയാവൂര്‍';
      case QTranslation.urduMaududi:
        return 'ابوالاعلی مودودی';
      default:
        return 'Clear Quran';
    }
  }
}
