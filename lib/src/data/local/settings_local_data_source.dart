import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  double getFontScale();

  Future<void> setFontScale(double fontSize);
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
}
