import '../entities/quran_setting.dart';

abstract class QuranSettingsRepository {
  Future<bool> saveSetting(
    QuranSetting setting,
    String newValue,
  );
  Future<String> getValue(QuranSetting setting);
}
