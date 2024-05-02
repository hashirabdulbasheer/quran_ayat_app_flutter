import 'dart:async';

import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/noble_quran.dart';

import '../../../misc/configs/app_config.dart';
import '../../../misc/enums/quran_app_mode_enum.dart';
import '../data/repository/settings_repository_impl.dart';
import 'constants/setting_constants.dart';
import 'entities/quran_dropdown_values_factory.dart';
import 'entities/quran_setting.dart';
import 'enum/settings_event_enum.dart';
import 'enum/settings_type_enum.dart';
import 'repository/settings_repository.dart';
import 'theme_manager.dart';

class QuranSettingsManager {
  static final QuranSettingsManager instance =
      QuranSettingsManager._privateConstructor();

  final StreamController<String> _settingsStream = StreamController.broadcast();

  // final QuranSetting _themeSettings = QuranSetting(
  //   name: "App Theme",
  //   description: "select the app color theme",
  //   id: QuranSettingsConstants.themeId,
  //   possibleValues:
  //       QuranDropdownValuesFactory.createValues(QuranSettingsConstants.themeId),
  //   defaultValue:
  //       QuranDropdownValuesFactory.defaultValue(QuranSettingsConstants.themeId),
  //   type: QuranSettingType.dropdown,
  // );

  final QuranSetting _transliterationSettings = QuranSetting(
    name: "Transliteration",
    description: "on/off transliteration",
    id: QuranSettingsConstants.transliterationId,
    possibleValues: QuranDropdownValuesFactory.createValues(
      QuranSettingsConstants.transliterationId,
    ),
    defaultValue: QuranDropdownValuesFactory.defaultValue(
      QuranSettingsConstants.transliterationId,
    ),
    type: QuranSettingType.onOff,
  );

  final QuranSetting _translationSettings = QuranSetting(
    name: "Translation",
    description: "select the translation",
    id: QuranSettingsConstants.translationId,
    possibleValues: QuranDropdownValuesFactory.createValues(
      QuranSettingsConstants.translationId,
    ),
    defaultValue: QuranDropdownValuesFactory.defaultValue(
      QuranSettingsConstants.translationId,
    ),
    type: QuranSettingType.multiselect,
  );

  final QuranSetting _audioControlSettings = QuranSetting(
    name: "Audio Controls",
    description: "on/off audio controls",
    id: QuranSettingsConstants.audioControlsId,
    possibleValues: QuranDropdownValuesFactory.createValues(
      QuranSettingsConstants.audioControlsId,
    ),
    defaultValue: QuranDropdownValuesFactory.defaultValue(
      QuranSettingsConstants.audioControlsId,
    ),
    type: QuranSettingType.onOff,
  );

  final QuranSetting _audioReciterSetting = QuranSetting(
    name: "Select reciter",
    description: "select your favorite reciter",
    id: QuranSettingsConstants.audioReciterId,
    showSearchBoxInDropdown: true,
    possibleValues: QuranDropdownValuesFactory.createValues(
      QuranSettingsConstants.audioReciterId,
    ),
    defaultValue: QuranDropdownValuesFactory.defaultValue(
      QuranSettingsConstants.audioReciterId,
    ),
    type: QuranSettingType.dropdown,
  );

  final QuranSetting _fontSizeSetting = QuranSetting(
    name: "Select font size",
    description: "adjust font size",
    id: QuranSettingsConstants.fontSizeId,
    showSearchBoxInDropdown: false,
    possibleValues: QuranDropdownValuesFactory.createValues(
      QuranSettingsConstants.audioReciterId,
    ),
    defaultValue: QuranDropdownValuesFactory.defaultValue(
      QuranSettingsConstants.audioReciterId,
    ),
    type: QuranSettingType.dropdown,
  );

  final QuranSetting _appModeSetting = QuranSetting(
    name: "Select Mode",
    description: "select a mode for the app",
    id: QuranSettingsConstants.appModeId,
    showSearchBoxInDropdown: false,
    possibleValues: QuranDropdownValuesFactory.createValues(
      QuranSettingsConstants.appModeId,
    ),
    defaultValue: QuranDropdownValuesFactory.defaultValue(
      QuranSettingsConstants.appModeId,
    ),
    type: QuranSettingType.dropdown,
  );

  final QuranSetting _challengeFeatureSettings = QuranSetting(
    name: "Challenges Feature",
    description: "on/off challenges feature (relaunch app to apply)",
    id: QuranSettingsConstants.challengedFeatureId,
    possibleValues: QuranDropdownValuesFactory.createValues(
      QuranSettingsConstants.challengedFeatureId,
    ),
    defaultValue: QuranDropdownValuesFactory.defaultValue(
      QuranSettingsConstants.challengedFeatureId,
    ),
    type: QuranSettingType.onOff,
  );

  QuranSettingsManager._privateConstructor();

  final double _fontScaleFactor = 0.2;

  List<QuranSetting> generateSettings() {
    List<QuranSetting> settings = [
      // _themeSettings,
      _appModeSetting,
      _translationSettings,
      _transliterationSettings,
      _audioControlSettings,
      _audioReciterSetting,
    ];

    settings.add(_challengeFeatureSettings);

    return settings;
  }

  void save(
    QuranSetting setting,
    String newValue,
  ) async {
    QuranSettingsRepository repository = QuranSettingsRepositoryImpl();
    await repository.saveSetting(
      setting,
      newValue,
    );
    _performSettingSpecificActions(setting);
  }

  Future<String> getValue(QuranSetting setting) {
    QuranSettingsRepository repository = QuranSettingsRepositoryImpl();

    return repository.getValue(setting);
  }

  Future<double> getFontScale() async {
    String fontScaleStr = await getValue(_fontSizeSetting);
    double fontSize = 1;
    if (double.tryParse(fontScaleStr) != null) {
      fontSize = double.parse(fontScaleStr);
    }

    return fontSize;
  }

  Future<void> resetFontSize() async {
    double fontSize = 1;
    save(
      _fontSizeSetting,
      "$fontSize",
    );

    return;
  }

  Future<void> incrementFontSize() async {
    double fontSize = await getFontScale();
    if (fontSize < _fontScaleFactor * 10) {
      fontSize = fontSize + _fontScaleFactor;
    }
    save(
      _fontSizeSetting,
      "$fontSize",
    );

    return;
  }

  Future<void> decrementFontSize() async {
    double fontSize = await getFontScale();
    if (fontSize > _fontScaleFactor * 2) {
      fontSize = fontSize - _fontScaleFactor;
    }
    save(
      _fontSizeSetting,
      "$fontSize",
    );

    return;
  }

  Future<bool> isTransliterationEnabled() async {
    String isEnabledStr = await getValue(_transliterationSettings);
    if (isEnabledStr == "On") {
      return true;
    }

    return false;
  }

  Future<bool> isAudioControlsEnabled() async {
    String isEnabledStr = await getValue(_audioControlSettings);
    if (isEnabledStr == "Off") {
      return false;
    }

    return true;
  }

  Future<bool> isChallengesFeatureEnabled() async {
    String isEnabledStr = await getValue(_challengeFeatureSettings);
    if (isEnabledStr == "Off") {
      return false;
    }

    return true;
  }

  Future<List<NQTranslation>> getTranslations() async {
    String translation = await getValue(_translationSettings);
    List<String> translationStringList = translation.split(",");

    return translationStringList
        .map((e) => NobleQuran.getTranslationFromTitle(e))
        .toList();
  }

  Future<String> getReciterKey() async {
    String reciter = await getValue(_audioReciterSetting);

    return reciter != "" ? reciter : QuranAppConfig.audioReciter;
  }

  Future<QuranAppMode> getAppMode() async {
    String modeString = await getValue(_appModeSetting);
    if (modeString.isEmpty) {
      return QuranAppMode.basic;
    }

    return QuranAppMode.values.firstWhere((e) => e.rawString() == modeString);
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
}
