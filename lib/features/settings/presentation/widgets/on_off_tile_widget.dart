import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/quran_setting.dart';
import '../../domain/settings_manager.dart';

class QuranOnOffSettingsTileWidget extends StatefulWidget {
  final QuranSetting setting;
  final bool defaultValue;
  final void Function(bool)? onChanged;

  const QuranOnOffSettingsTileWidget({
    Key? key,
    required this.setting,
    required this.defaultValue,
    this.onChanged,
  }) : super(key: key);

  @override
  State<QuranOnOffSettingsTileWidget> createState() =>
      _QuranOnOffSettingsTileWidgetState();
}

class _QuranOnOffSettingsTileWidgetState
    extends State<QuranOnOffSettingsTileWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: QuranSettingsManager.instance.getValue(widget.setting),
      builder: (
        context,
        snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _tile();
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              bool isSwitched = false;
              if (snapshot.data == "true") {
                  isSwitched = true;
              } else if (snapshot.data == "false") {
                  isSwitched = false;
              } else {
                isSwitched = widget.defaultValue;
              }

              return _tile(
                isSwitched: isSwitched,
              );
            }
        }
      },
    );
  }

  void _onSwitchValueChanged(bool value) {
    setState(() {});
    Function(bool)? onChangedPram = widget.onChanged;
    if (onChangedPram != null) {
      onChangedPram(value);
    }
  }

  Widget _tile({
    bool? isSwitched,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        trailing: CupertinoSwitch(
          activeColor: Theme.of(context).primaryColor,
          value: isSwitched ?? false,
          onChanged: (value) => _onSwitchValueChanged(value),
        ),
        title: Text(
          widget.setting.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(widget.setting.description),
      ),
    );
  }
}
