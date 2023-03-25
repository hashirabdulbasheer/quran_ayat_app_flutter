import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/reciter.dart';
import 'package:noble_quran/noble_quran.dart';

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
                  title: "${e.name} (${e.bitrate})",
                  content: e,
                  key: e.subfolder,
                ))
            .toList();
    }

    return [];
  }

  static QuranDropdownValue? defaultValue(String typeId) {
    switch (typeId) {
      case QuranSettingsConstants.themeId:
        return QuranDropdownValue.sameValues(QuranAppTheme.dark.rawString());

      case QuranSettingsConstants.transliterationId:
        return QuranDropdownValue.sameValues(QuranSettingOnOff.off.rawString());

      case QuranSettingsConstants.translationId:
        return QuranDropdownValue.sameValues(NQTranslation.haleem.title);

      case QuranSettingsConstants.audioControlsId:
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
