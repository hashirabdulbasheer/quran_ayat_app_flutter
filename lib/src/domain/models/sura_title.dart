import 'package:equatable/equatable.dart';

class SuraTitle extends Equatable {
  final int number;
  final String name;
  final String transliterationEn;
  final String translationEn;
  final int totalVerses;

  const SuraTitle({
    required this.number,
    required this.name,
    required this.transliterationEn,
    required this.translationEn,
    required this.totalVerses,
  });

  const SuraTitle.defaultValue()
      : number = 1,
        name = "سورة الفاتحة",
        transliterationEn = "Al-Faatiha",
        translationEn = "The Opening",
        totalVerses = 7;

  // used by dropdown widget during search
  @override
  String toString() {
    return number.toString();
  }

  @override
  List<Object?> get props => [
        number,
        name,
        transliterationEn,
        translationEn,
        totalVerses,
      ];
}
