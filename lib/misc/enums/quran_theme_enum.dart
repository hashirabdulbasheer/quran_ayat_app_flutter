/// Quran App Themes
enum QuranAppTheme { light, dark }

extension QuranAppThemeToString on QuranAppTheme {
  String rawString() {
    switch (this) {
      case QuranAppTheme.light:
        return "Light";
      case QuranAppTheme.dark:
        return "Dark";
    }
  }
}
