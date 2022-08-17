import '../enum/settings_type_enum.dart';

class QuranSetting {
  final String name;
  final String description;
  final String id; // unique id for the setting
  final List<String> possibleValues;
  final String defaultValue;
  final QuranSettingType type;

  const QuranSetting(
      {required this.name,
      required this.id,
      required this.description,
      required this.possibleValues,
      required this.defaultValue,
      required this.type});
}
