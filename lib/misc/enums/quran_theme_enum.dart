
/// Quran App Themes
enum QuranAppTheme { light, dark }

extension QuranAppThemeToString on QuranAppTheme {
  String rawString() {
    switch (this) {
      case QuranAppTheme.light:
        return "light_theme";
      case QuranAppTheme.dark:
        return "dark_theme";
    }
  }
}
