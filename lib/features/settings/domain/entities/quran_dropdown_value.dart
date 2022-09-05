/// Used as possibleValues for settings dropdown
class QuranDropdownValue {
  final String title;
  final String key;
  final dynamic content;

  QuranDropdownValue({required this.title, required this.key, required this.content});

  QuranDropdownValue.sameValues(this.title): content = title, key = title;

}
