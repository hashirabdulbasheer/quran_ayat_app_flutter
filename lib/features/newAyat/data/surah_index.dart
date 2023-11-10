import 'dart:math';

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

  // construct a surah index from a human sura index that starts with 1
  const SurahIndex.fromHuman({
    required int sura,
    required int aya,
  })  : sura = sura - 1,
        aya = aya - 1;

  // index exposed to outside world
  SurahIndex get human => SurahIndex(
        sura + 1,
        aya + 1,
      );

  SurahIndex copyWith({
    int? sura,
    int? aya,
  }) {
    return SurahIndex(
      sura ?? this.sura,
      aya ?? this.aya,
    );
  }

  static const SurahIndex defaultIndex = SurahIndex(
    0,
    0,
  );

  SurahIndex previous() => SurahIndex(
        sura,
        max(
          aya - 1,
          0,
        ),
      );

  SurahIndex next() => SurahIndex(
        sura,
        aya + 1,
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
