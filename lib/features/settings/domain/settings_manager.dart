import 'dart:async';

import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/noble_quran.dart';
import '../../../misc/configs/app_config.dart';
import 'constants/setting_constants.dart';
import 'entities/quran_dropdown_values_factory.dart';
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
      id: QuranSettingsConstants.themeId,
      possibleValues: QuranDropdownValuesFactory.createValues(QuranSettingsConstants.themeId),
      defaultValue: QuranDropdownValuesFactory.defaultValue(QuranSettingsConstants.themeId),
      type: QuranSettingType.dropdown,);

  final QuranSetting _transliterationSettings = QuranSetting(
      name: "Transliteration",
      description: "on/off transliteration",
      id: QuranSettingsConstants.transliterationId,
      possibleValues: QuranDropdownValuesFactory.createValues(QuranSettingsConstants.transliterationId),
      defaultValue: QuranDropdownValuesFactory.defaultValue(QuranSettingsConstants.transliterationId),
      type: QuranSettingType.onOff,);

  final QuranSetting _translationSettings = QuranSetting(
      name: "Translation",
      description: "select the translation",
      id: QuranSettingsConstants.translationId,
      possibleValues: QuranDropdownValuesFactory.createValues(QuranSettingsConstants.translationId),
      defaultValue: QuranDropdownValuesFactory.defaultValue(QuranSettingsConstants.translationId),
      type: QuranSettingType.dropdown,);

  final QuranSetting _audioControlSettings = QuranSetting(
      name: "Audio Controls",
      description: "on/off audio controls",
      id: QuranSettingsConstants.audioControlsId,
      possibleValues: QuranDropdownValuesFactory.createValues(QuranSettingsConstants.audioControlsId),
      defaultValue: QuranDropdownValuesFactory.defaultValue(QuranSettingsConstants.audioControlsId),
      type: QuranSettingType.onOff,);

  final QuranSetting _audioReciterSetting = QuranSetting(
      name: "Select reciter",
      description: "select your favorite reciter",
      id: QuranSettingsConstants.audioReciterId,
      showSearchBoxInDropdown: true,
      possibleValues: QuranDropdownValuesFactory.createValues(QuranSettingsConstants.audioReciterId),
      defaultValue: QuranDropdownValuesFactory.defaultValue(QuranSettingsConstants.audioReciterId),
      type: QuranSettingType.dropdown,);

  List<QuranSetting> generateSettings() {
    return [
      _themeSettings,
      _translationSettings,
      _transliterationSettings,
      _audioControlSettings,
      _audioReciterSetting,
    ];
  }

  void save(QuranSetting setting, String newValue,) async {
    QuranSettingsRepository repository = QuranSettingsRepositoryImpl();
    await repository.saveSetting(setting, newValue,);
    _performSettingSpecificActions(setting);
  }

  Future<String> getValue(QuranSetting setting) {
    QuranSettingsRepository repository = QuranSettingsRepositoryImpl();

    return repository.getValue(setting);
  }

  void _performSettingSpecificActions(QuranSetting setting) {
    if (setting.id == QuranSettingsConstants.themeId) {
      /// Update theme
      QuranThemeManager.instance.themeChanged();
    } else if (setting.id == QuranSettingsConstants.transliterationId) {
      /// Update transliteration
      QuranSettingsManager.instance
          .notifyListeners(QuranSettingsEvent.transliterationChanged);
    } else if (setting.id == QuranSettingsConstants.translationId) {
      /// Update translation
      QuranSettingsManager.instance
          .notifyListeners(QuranSettingsEvent.translationChanged);
    } else if (setting.id == QuranSettingsConstants.audioControlsId) {
      /// Update audio controls
      QuranSettingsManager.instance
          .notifyListeners(QuranSettingsEvent.audioControlStatusChanged);
    }
  }

  Future<bool> isTransliterationEnabled() async {
    String isEnabledStr = await getValue(_transliterationSettings);
    if (isEnabledStr == "true") {
      return true;
    }

    return false;
  }

  Future<bool> isAudioControlsEnabled() async {
    String isEnabledStr = await getValue(_audioControlSettings);
    if (isEnabledStr == "true") {
      return true;
    }

    return false;
  }

  Future<NQTranslation> getTranslation() async {
    String translation = await getValue(_translationSettings);

    return NobleQuran.getTranslationFromTitle(translation);
  }

  Future<String> getReciterKey() async {
    String reciter = await getValue(_audioReciterSetting);

    return reciter != "" ? reciter : QuranAppConfig.audioReciter;
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
