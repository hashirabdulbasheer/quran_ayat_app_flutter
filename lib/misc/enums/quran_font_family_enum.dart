/// enum for fonts used by the app
enum QuranFontFamily { arabic, malayalam }

extension QuranFontFamilyToString on QuranFontFamily {
  String get rawString {
    switch (this) {
      case QuranFontFamily.arabic:
        return "KFGQPC Uthmanic Script HAFS Regular";
      case QuranFontFamily.malayalam:
        return "Manjari Regular";
    }
  }
}
