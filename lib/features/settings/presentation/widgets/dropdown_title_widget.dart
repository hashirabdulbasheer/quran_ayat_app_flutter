import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/quran_setting.dart';
import '../../domain/settings_manager.dart';

class QuranDropdownSettingsTileWidget extends StatefulWidget {
  final QuranSetting setting;
  final void Function(String)? onChanged;

  const QuranDropdownSettingsTileWidget(
      {Key? key, required this.setting, this.onChanged})
      : super(key: key);

  @override
  State<QuranDropdownSettingsTileWidget> createState() =>
      _QuranDropdownSettingsTileWidgetState();
}

class _QuranDropdownSettingsTileWidgetState
    extends State<QuranDropdownSettingsTileWidget> {
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
                return _tile(currentValue: snapshot.data);
              }
          }
        });
  }

  Widget _tile({String? currentValue}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        isThreeLine: true,
        title: Text(widget.setting.name,
            style: Theme.of(context).textTheme.titleLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.setting.description, textAlign: TextAlign.end),
            IntrinsicWidth(
              child: DropdownSearch<String>(
                items: widget.setting.possibleValues,
                dropdownSearchTextAlign: TextAlign.start,
                popupProps:
                    const PopupPropsMultiSelection.menu(fit: FlexFit.loose),
                dropdownSearchDecoration:
                    const InputDecoration(hintText: "select"),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {});
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  }
                },
                selectedItem: currentValue,
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
