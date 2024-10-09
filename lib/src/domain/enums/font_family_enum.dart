/// enum for fonts used by the app
enum QFontFamily { arabic, malayalam }

/// https://fonts.qurancomplex.gov.sa/wp02/en/%D8%AD%D9%81%D8%B5/
extension QFontFamilyToString on QFontFamily {
  String get rawString {
    switch (this) {
      case QFontFamily.arabic:
        return "KFGQPC HAFS Uthmanic Script Regular";
      case QFontFamily.malayalam:
        return "Manjari Regular";
    }
  }
}
