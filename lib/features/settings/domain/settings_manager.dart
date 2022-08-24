import 'dart:async';

import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/noble_quran.dart';

import '../../../misc/enums/quran_theme_enum.dart';
import 'enum/settings_event_enum.dart';
import 'theme_manager.dart';
import '../data/repository/settings_repository_impl.dart';
import 'entities/quran_setting.dart';
import 'enum/settings_type_enum.dart';
import 'repository/settings_repository.dart';

class QuranSettingsManager {
  QuranSettingsManager._privateConstructor();

  static final QuranSettingsManager instance =
      QuranSettingsManager._privateConstructor();

  final StreamController<String> _settingsStream = StreamController.broadcast();

  final QuranSetting _themeSettings = QuranSetting(
      name: "App Theme",
      description: "select the app color theme",
      id: QuranThemeManager.instance.themeId,
      possibleValues: [
        QuranAppTheme.light.rawString(),
        QuranAppTheme.dark.rawString()
      ],
      defaultValue: QuranAppTheme.light.rawString(),
      type: QuranSettingType.dropdown);

  final QuranSetting _transliterationSettings = QuranSetting(
      name: "Transliteration",
      description: "on/off transliteration",
      id: QuranThemeManager.instance.transliterationId,
      possibleValues: [],
      defaultValue: QuranSettingOnOff.off.rawString(),
      type: QuranSettingType.onOff);

  final QuranSetting _translationSettings = QuranSetting(
      name: "Translation",
      description: "select the translation",
      id: QuranThemeManager.instance.translationId,
      possibleValues:
          NobleQuran.getAllTranslations().map((e) => e.title).toList(),
      defaultValue: NQTranslation.clear.title,
      type: QuranSettingType.dropdown);

  List<QuranSetting> generateSettings() {
    return [_themeSettings, _translationSettings, _transliterationSettings];
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
    } else if (setting.id == QuranThemeManager.instance.transliterationId) {
      /// Update transliteration
      QuranSettingsManager.instance
          .notifyListeners(QuranSettingsEvent.transliterationChanged);
    } else if (setting.id == QuranThemeManager.instance.translationId) {
      /// Update translation
      QuranSettingsManager.instance
          .notifyListeners(QuranSettingsEvent.translationChanged);
    }
  }

  Future<bool> isTransliterationEnabled() async {
    String isEnabledStr = await getValue(_transliterationSettings);
    if (isEnabledStr == "true") {
      return true;
    }
    return false;
  }

  Future<NQTranslation> getTranslation() async {
    String translation = await getValue(_translationSettings);
    return NobleQuran.getTranslationFromTitle(translation);
  }

  /// register a listener to get theme update events
  void registerListener(void Function(String) listener) {
    _settingsStream.stream.listen(listener);
  }

  /// remove all theme update event listeners
  void removeListeners() {
    _settingsStream.stream.listen(null);
  }

  /// notify listeners of events
  void notifyListeners(QuranSettingsEvent event) {
    _settingsStream.add(event.rawString());
  }
}
