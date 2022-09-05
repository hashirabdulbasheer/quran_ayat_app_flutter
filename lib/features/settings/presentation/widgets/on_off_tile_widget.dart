import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/quran_setting.dart';
import '../../domain/settings_manager.dart';

class QuranOnOffSettingsTileWidget extends StatefulWidget {
  final QuranSetting setting;
  final void Function(bool)? onChanged;

  const QuranOnOffSettingsTileWidget(
      {Key? key, required this.setting, this.onChanged})
      : super(key: key);

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
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return _tile();
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                bool isSwitched = snapshot.data == "true" ? true : false;
                return _tile(
                    isSwitched: isSwitched,
                    trailing: CupertinoSwitch(
                      activeColor: Theme.of(context).primaryColor,
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {});
                        widget.onChanged ?? widget.onChanged!(value);
                      },
                    ));
              }
          }
        });
  }

  Widget _tile({bool? isSwitched, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          trailing: CupertinoSwitch(
            activeColor: Theme.of(context).primaryColor,
            value: isSwitched ?? false,
            onChanged: (value) {
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
          title: Text(widget.setting.name,
              style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(widget.setting.description)),
    );
  }
}
