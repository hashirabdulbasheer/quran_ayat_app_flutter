import 'package:ayat_app/src/data/models/local/enums/local_theme_mode_enum.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  double getFontScale();

  Future<void> setFontScale(double fontSize);

  LocalThemeMode getThemeMode();

  Future<void> setThemeMode(LocalThemeMode mode);
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
}
