import '../../presentation/home/home.dart';

abstract class SettingsRepository {
  double getFontScale();

  Future<void> setFontScale(double fontSize);

  ThemeMode getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);

  QTranslation getDefaultTranslation();

  Future<void> setDefaultTranslation(QTranslation translation);

  bool getIsWordByWordTranslationEnabled();

  Future<void> setIsWordByWordTranslationEnabled(bool isEnabled);
}
