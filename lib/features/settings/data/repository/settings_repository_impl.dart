import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/quran_setting.dart';
import '../../domain/repository/settings_repository.dart';

class QuranSettingsRepositoryImpl implements QuranSettingsRepository {
  @override
  Future<String> getValue(QuranSetting setting) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(setting.id) ?? setting.defaultValue?.key ?? "";
  }

  @override
  Future<bool> saveSetting(
    QuranSetting setting,
    String newValue,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      setting.id,
      newValue,
    );

    return true;
  }
}
