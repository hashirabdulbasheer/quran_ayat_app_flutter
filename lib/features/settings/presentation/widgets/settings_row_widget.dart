import 'package:flutter/material.dart';

import '../../domain/entities/quran_setting.dart';
import '../../domain/enum/settings_type_enum.dart';
import '../../domain/settings_manager.dart';
import 'dropdown_title_widget.dart';
import 'on_off_tile_widget.dart';

class QuranSettingsRowWidget extends StatelessWidget {
  const QuranSettingsRowWidget({
    Key? key,
    required this.setting,
  }) : super(key: key);

  final QuranSetting setting;

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
          },
        );

      case QuranSettingType.onOff:
        return QuranOnOffSettingsTileWidget(
          setting: setting,
          onChanged: (value) => {
            QuranSettingsManager.instance.save(
              setting,
              "$value",
            ),
          },
        );

      default:
        return Container();
    }
  }
}
