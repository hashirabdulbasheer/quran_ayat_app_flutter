import 'package:flutter/material.dart';
import 'package:quran_ayat/misc/enums/quran_theme_enum.dart';
import '../domain/entities/quran_setting.dart';
import '../domain/enum/settings_type_enum.dart';
import '../domain/settings_manager.dart';

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
          appBar: AppBar(title: const Text("Settings")),
          body: _body(context)),
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
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: FutureBuilder<String>(
            future: QuranSettingsManager.instance.getValue(setting),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListTile(
                        trailing: _settingAction(setting, snapshot.data),
                        title: Text(setting.name,
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge),
                        subtitle: Text(setting.description));
                  }
              }
            }),
      ),
    );
  }

  Widget _settingAction(QuranSetting setting, String? currentValue) {
    switch (setting.type) {
      case QuranSettingType.dropdown:
        return DropdownButton<String>(
            value: currentValue ?? QuranAppTheme.light.rawString(),
            items: setting.possibleValues
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value, child: Text(value));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                QuranSettingsManager.instance.save(setting, value);
                setState(() {});
              }
            });

      case QuranSettingType.onOff:
        bool isSwitched = currentValue == "true" ? true : false;
        return Switch(
          value: isSwitched,
          onChanged: (value) {
            QuranSettingsManager.instance.save(setting, "$value");
            setState(() {});
          },
        );

      default:
        return Container();
    }
  }
}
