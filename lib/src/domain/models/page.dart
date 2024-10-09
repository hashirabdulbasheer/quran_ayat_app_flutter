import 'package:ayat_app/src/domain/models/surah_index.dart';

class QPage {
  final int number;
  final SurahIndex firstAyaIndex;
  final SurahIndex? selectedAyaIndex;
  final int numberOfAya;

  QPage(
      {required this.number,
      required this.firstAyaIndex,
      required this.numberOfAya,
      this.selectedAyaIndex});

  QPage next(int numAyaPerPage) {
    return QPage(
      number: number + 1,
      firstAyaIndex: firstAyaIndex.next(numAyaPerPage),
      numberOfAya: numAyaPerPage,
    );
  }

  QPage previous(int numAyaPerPage) {
    return QPage(
      number: number - 1,
      firstAyaIndex: firstAyaIndex.previous(numAyaPerPage),
      numberOfAya: numAyaPerPage,
    );
  }

  @override
  String toString() {
    return "number: $number, startIndex: $firstAyaIndex, numberOfAya: $numberOfAya, selected: $selectedAyaIndex";
  }
}
