/// enum for fonts used by the app
enum QuranFontFamily { arabic, malayalam }

/// https://fonts.qurancomplex.gov.sa/wp02/en/%D8%AD%D9%81%D8%B5/
extension QuranFontFamilyToString on QuranFontFamily {
  String get rawString {
    switch (this) {
      case QuranFontFamily.arabic:
        return "KFGQPC HAFS Uthmanic Script Regular";
      case QuranFontFamily.malayalam:
        return "Manjari Regular";
    }
  }
}
