enum LocalThemeMode { dark, light }

extension LocalThemeModeExtension on LocalThemeMode {
  String get rawString {
    switch (this) {
      case LocalThemeMode.dark:
        return "dark";
      case LocalThemeMode.light:
        return "light";
    }
  }
}
