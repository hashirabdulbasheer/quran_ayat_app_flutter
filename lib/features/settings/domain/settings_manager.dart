import '../../../misc/enums/quran_theme_enum.dart';
import 'theme_manager.dart';
import '../data/repository/settings_repository_impl.dart';
import 'entities/quran_setting.dart';
import 'enum/settings_type_enum.dart';
import 'repository/settings_repository.dart';

class QuranSettingsManager {
  QuranSettingsManager._privateConstructor();

  static final QuranSettingsManager instance =
      QuranSettingsManager._privateConstructor();

  List<QuranSetting> generateSettings() {
    QuranSetting themeSettings = QuranSetting(
        name: "App Theme",
        description: "select the app color theme",
        id: QuranThemeManager.instance.themeId,
        possibleValues: [
          QuranAppTheme.light.rawString(),
          QuranAppTheme.dark.rawString()
        ],
        defaultValue: QuranAppTheme.light.rawString(),
        type: QuranSettingType.dropdown);

    return [themeSettings];
  }

  void save(QuranSetting setting, String newValue) async {
    QuranSettingsRepository repository = QuranSettingsRepositoryImpl();
    await repository.saveSetting(setting, newValue);
    _performSettingSpecificActions(setting);
  }

  Future<String> getValue(QuranSetting setting) {
    QuranSettingsRepository repository = QuranSettingsRepositoryImpl();
    return repository.getValue(setting);
  }

  void _performSettingSpecificActions(QuranSetting setting) {
    if (setting.id == QuranThemeManager.instance.themeId) {
      /// Update theme
      QuranThemeManager.instance.themeChanged();
    }
  }
}
