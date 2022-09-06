import '../enum/settings_type_enum.dart';
import 'quran_dropdown_value.dart';

class QuranSetting {
  final String name;
  final String description;
  final String id; // unique id for the setting
  final List<QuranDropdownValue> possibleValues;
  final QuranDropdownValue? defaultValue;
  final bool? showSearchBoxInDropdown;
  final QuranSettingType type;

  const QuranSetting({
    required this.name,
    required this.id,
    required this.description,
    required this.possibleValues,
    this.showSearchBoxInDropdown,
    this.defaultValue,
    required this.type,
  });
}
