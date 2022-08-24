import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../misc/enums/quran_theme_enum.dart';
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
                      return _settingRowContents(setting, snapshot.data);
                    }
                }
              }),
        ),
      ),
    );
  }

  Widget _settingRowContents(QuranSetting setting, String? currentValue) {
    switch (setting.type) {
      case QuranSettingType.dropdown:
        return _dropdownTile(setting, currentValue);

      case QuranSettingType.onOff:
        return _onOffTile(setting, currentValue);

      default:
        return Container();
    }
  }

  Widget _onOffTile(QuranSetting setting, String? currentValue) {
    bool isSwitched = currentValue == "true" ? true : false;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          trailing: CupertinoSwitch(
            activeColor: Theme.of(context).primaryColor,
            value: isSwitched,
            onChanged: (value) {
              QuranSettingsManager.instance.save(setting, "$value");
              setState(() {});
            },
          ),
          title:
              Text(setting.name, style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(setting.description)),
    );
  }

  Widget _dropdownTile(QuranSetting setting, String? currentValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        isThreeLine: true,
        title:
            Text(setting.name, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(setting.description, textAlign: TextAlign.end),
            IntrinsicWidth(
              child: DropdownSearch<String>(
                items: setting.possibleValues,
                dropdownSearchTextAlign: TextAlign.start,
                popupProps:
                    const PopupPropsMultiSelection.menu(fit: FlexFit.loose),
                dropdownSearchDecoration:
                    const InputDecoration(hintText: "select"),
                onChanged: (value) {
                  if (value != null) {
                    QuranSettingsManager.instance.save(setting, value);
                    setState(() {});
                  }
                },
                selectedItem: currentValue ?? QuranAppTheme.light.rawString(),
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
