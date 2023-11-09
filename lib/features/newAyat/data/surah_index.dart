import 'package:equatable/equatable.dart';
import 'package:noble_quran/models/bookmark.dart';

class SurahIndex extends Equatable {
  final int sura;
  final int aya;

  const SurahIndex(
    this.sura,
    this.aya,
  );

  SurahIndex.fromBookmark(NQBookmark bookmark)
      : sura = bookmark.surah - 1,
        aya = bookmark.ayat;

  // index exposed to outside world
  SurahIndex get human => SurahIndex(
        sura + 1,
        aya,
      );

  @override
  String toString() {
    return '{SurahIndex: surahIndex: $sura, ayaIndex: $aya}';
  }

  @override
  List<Object?> get props => [
        sura,
        aya,
      ];
}
