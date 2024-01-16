import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/reciter.dart';
import 'package:noble_quran/noble_quran.dart';

import '../../../../misc/enums/quran_app_mode_enum.dart';
import '../../../../misc/enums/quran_theme_enum.dart';
import '../constants/setting_constants.dart';
import '../enum/settings_type_enum.dart';
import 'quran_dropdown_value.dart';

class QuranDropdownValuesFactory {
  static List<QuranDropdownValue> createValues(String typeId) {
    switch (typeId) {
      case QuranSettingsConstants.themeId:
        return [
          QuranDropdownValue.sameValues(QuranAppTheme.light.rawString()),
          QuranDropdownValue.sameValues(QuranAppTheme.dark.rawString()),
        ];

      case QuranSettingsConstants.translationId:
        return NobleQuran.getAllTranslations()
            .map((e) => QuranDropdownValue.sameValues(e.title))
            .toList();

      case QuranSettingsConstants.audioReciterId:
        return NobleQuran.getAllReciters()
            .map((e) => QuranDropdownValue(
                  title: e.name,
                  content: e,
                  key: e.subfolder,
                ))
            .toList();

      case QuranSettingsConstants.appModeId:
        return [
          QuranDropdownValue.sameValues(QuranAppMode.basic.rawString()),
          QuranDropdownValue.sameValues(QuranAppMode.advanced.rawString()),
        ];
    }

    return [];
  }

  static QuranDropdownValue? defaultValue(String typeId) {
    switch (typeId) {
      case QuranSettingsConstants.themeId:
        return QuranDropdownValue.sameValues(QuranAppTheme.light.rawString());

      case QuranSettingsConstants.transliterationId:
        return QuranDropdownValue.sameValues(QuranSettingOnOff.off.rawString());

      case QuranSettingsConstants.translationId:
        return QuranDropdownValue.sameValues(
          NQTranslation.wahiduddinkhan.title,
        );

      case QuranSettingsConstants.audioControlsId:
        return QuranDropdownValue.sameValues(QuranSettingOnOff.off.rawString());

      case QuranSettingsConstants.appModeId:
        return QuranDropdownValue.sameValues(QuranAppMode.basic.rawString());

      case QuranSettingsConstants.challengedFeatureId:
        return QuranDropdownValue.sameValues(QuranSettingOnOff.on.rawString());

      case QuranSettingsConstants.audioReciterId:

        /// default reciter
        QuranReciter reciter = QuranReciter(
          subfolder: "khalefa_al_tunaiji_64kbps",
          name: "Khalefa Al-Tunaiji",
          bitrate: "64kbps",
        );
        return QuranDropdownValue(
          title: "Khalefa Al-Tunaiji (64kbps)",
          key: "khalefa_al_tunaiji_64kbps",
          content: reciter,
        );
    }

    return null;
  }
}
