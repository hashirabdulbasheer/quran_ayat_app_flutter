import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/quran_dropdown_value.dart';
import '../../domain/entities/quran_setting.dart';
import '../../domain/settings_manager.dart';

class QuranMultiselectSettingsTileWidget extends StatefulWidget {
  final QuranSetting setting;
  final bool? showSearchBox;
  final void Function(List<QuranDropdownValue>)? onChanged;

  const QuranMultiselectSettingsTileWidget({
    Key? key,
    required this.setting,
    this.showSearchBox,
    this.onChanged,
  }) : super(key: key);

  @override
  State<QuranMultiselectSettingsTileWidget> createState() =>
      _QuranDropdownSettingsTileWidgetState();
}

class _QuranDropdownSettingsTileWidgetState
    extends State<QuranMultiselectSettingsTileWidget> {
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
              List<String> values = snapshot.data?.split(",") ?? [];

              return _tile(
                currentValue: _dropdownValueFromKey(values),
              );
            }
        }
      },
    );
  }

  Widget _tile({List<QuranDropdownValue>? currentValue}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        isThreeLine: true,
        title: Text(
          widget.setting.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.setting.description,
              textAlign: TextAlign.end,
            ),
            IntrinsicWidth(
              child: DropdownSearch<QuranDropdownValue>.multiSelection(
                items: widget.setting.possibleValues,
                itemAsString: (item) => item.title,
                popupProps: PopupPropsMultiSelection.dialog(
                  fit: FlexFit.loose,
                  showSearchBox: widget.showSearchBox ?? false,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(hintText: "select"),
                ),
                onChanged: _onDropDownValueChanged,
                selectedItems: currentValue ?? [],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _onDropDownValueChanged(List<QuranDropdownValue>? values) {
    if (values != null && values.isNotEmpty) {
      setState(() {});
      Function(List<QuranDropdownValue>)? onChangedParam = widget.onChanged;
      if (onChangedParam != null && values.isNotEmpty) {
        onChangedParam(values);
      }
    }
  }

  List<QuranDropdownValue>? _dropdownValueFromKey(List<String>? values) {
    if (values != null && values.isNotEmpty) {
      List<QuranDropdownValue> possibleValues = widget.setting.possibleValues;
      List<QuranDropdownValue> filtered = possibleValues
          .where((element) => values?.contains(element.key) ?? false)
          .toList();
      print("_dropdownValueFromKey ${filtered.length}");
      if (filtered.isNotEmpty) {
        return filtered;
      }
    }

    return null;
  }
}
