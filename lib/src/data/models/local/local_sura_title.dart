import 'package:equatable/equatable.dart';

class LocalSuraTitle extends Equatable {
  final int number;
  final String name;
  final String transliterationEn;
  final String translationEn;
  final int totalVerses;

  const LocalSuraTitle({
    required this.number,
    required this.name,
    required this.transliterationEn,
    required this.translationEn,
    required this.totalVerses,
  });

  const LocalSuraTitle.defaultValue()
      : number = 1,
        name = "سورة الفاتحة",
        transliterationEn = "Al-Faatiha",
        translationEn = "The Opening",
        totalVerses = 7;

  @override
  List<Object?> get props =>
      [
        number,
        name,
        transliterationEn,
        translationEn,
        totalVerses,
      ];
}
