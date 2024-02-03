import 'package:flutter/material.dart';

import '../../domain/entities/quran_setting.dart';
import '../../domain/enum/settings_type_enum.dart';
import '../../domain/settings_manager.dart';
import 'dropdown_title_widget.dart';
import 'multiselect_dropdown_title_widget.dart';
import 'on_off_tile_widget.dart';

class QuranSettingsRowWidget extends StatelessWidget {
  final QuranSetting setting;
  final Function onChanged;

  const QuranSettingsRowWidget({
    Key? key,
    required this.setting,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (setting.type) {
      case QuranSettingType.dropdown:
        return QuranDropdownSettingsTileWidget(
          setting: setting,
          showSearchBox: setting.showSearchBoxInDropdown,
          onChanged: (value) => {
            QuranSettingsManager.instance.save(
              setting,
              value.key,
            ),
            onChanged(),
          },
        );

      case QuranSettingType.onOff:
        return QuranOnOffSettingsTileWidget(
          setting: setting,
          defaultValue:
              setting.defaultValue?.title == QuranSettingOnOff.on.rawString(),
          onChanged: (value) => {
            QuranSettingsManager.instance.save(
              setting,
              value
                  ? QuranSettingOnOff.on.rawString()
                  : QuranSettingOnOff.off.rawString(),
            ),
            onChanged(),
          },
        );

      case QuranSettingType.multiselect:
        return QuranMultiselectSettingsTileWidget(
          setting: setting,
          showSearchBox: setting.showSearchBoxInDropdown,
          onChanged: (values) => {
            QuranSettingsManager.instance.save(
              setting,
              values.map((e) => e.key).toList().join(","),
            ),
            onChanged(),
          },
        );

      default:
        return Container();
    }
  }
}
