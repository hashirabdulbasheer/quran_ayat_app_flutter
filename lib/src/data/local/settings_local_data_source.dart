import 'package:ayat_app/src/data/models/local/enums/local_theme_mode_enum.dart';
import 'package:injectable/injectable.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  double getFontScale();

  Future<void> setFontScale(double fontSize);

  LocalThemeMode getThemeMode();

  Future<void> setThemeMode(LocalThemeMode mode);

  NQTranslation getDefaultTranslation();

  Future<void> setDefaultTranslation(NQTranslation translation);

  bool getIsWordByWordTranslationEnabled();

  Future<void> setIsWordByWordTranslationEnabled(bool isEnabled);
}

@Injectable(as: SettingsDataSource)
class SettingsLocalDataSourceImpl extends SettingsDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  double getFontScale() {
    double? savedFontSize = sharedPreferences.getDouble("quran_app_font_size");
    return savedFontSize ?? 1.0;
  }

  @override
  Future<void> setFontScale(double fontSize) async {
    await sharedPreferences.setDouble("quran_app_font_size", fontSize);
  }

  @override
  LocalThemeMode getThemeMode() {
    String? themeMode = sharedPreferences.getString("quran_theme_mode");
    return themeMode == LocalThemeMode.dark.rawString
        ? LocalThemeMode.dark
        : LocalThemeMode.light;
  }

  @override
  Future<void> setThemeMode(LocalThemeMode mode) async {
    await sharedPreferences.setString("quran_theme_mode", mode.rawString);
  }

  @override
  NQTranslation getDefaultTranslation() {
    String translationTitle =
        sharedPreferences.getString("quran_default_translation") ??
            NQTranslation.wahiduddinkhan.title;
    return NobleQuran.getTranslationFromTitle(translationTitle);
  }

  @override
  Future<void> setDefaultTranslation(NQTranslation translation) async {
    await sharedPreferences.setString(
      "quran_default_translation",
      translation.title,
    );
  }

  @override
  bool getIsWordByWordTranslationEnabled() {
    return sharedPreferences.getBool("quran_word_translation_enabled") ?? true;
  }

  @override
  Future<void> setIsWordByWordTranslationEnabled(bool isEnabled) async {
    await sharedPreferences.setBool(
      "quran_word_translation_enabled",
      isEnabled,
    );
  }
}
