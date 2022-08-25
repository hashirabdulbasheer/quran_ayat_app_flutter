import 'package:flutter/material.dart';
import '../domain/entities/quran_setting.dart';
import '../domain/enum/settings_type_enum.dart';
import '../domain/settings_manager.dart';
import 'widgets/dropdown_title_widget.dart';
import 'widgets/on_off_tile_widget.dart';

class QuranSettingsScreen extends StatefulWidget {
  const QuranSettingsScreen({Key? key}) : super(key: key);

  @override
  State<QuranSettingsScreen> createState() => _QuranSettingsScreenState();
}

class _QuranSettingsScreenState extends State<QuranSettingsScreen> {
  /// generate settings
  late List<QuranSetting> _settings;

  @override
  void initState() {
    super.initState();
    _settings = QuranSettingsManager.instance.generateSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(title: const Text("Settings")), body: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _settingRow(_settings[index]);
          },
          itemCount: _settings.length,
        ));
  }

  Widget _settingRow(QuranSetting setting) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: IntrinsicHeight(
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: _settingRowContents(setting)),
      ),
    );
  }

  Widget _settingRowContents(QuranSetting setting) {
    switch (setting.type) {
      case QuranSettingType.dropdown:
        return QuranDropdownSettingsTileWidget(
            setting: setting,
            onChanged: (value) {
              QuranSettingsManager.instance.save(setting, value);
            });

      case QuranSettingType.onOff:
        return QuranOnOffSettingsTileWidget(
            setting: setting,
            onChanged: (value) {
              QuranSettingsManager.instance.save(setting, "$value");
            });

      default:
        return Container();
    }
  }
}
