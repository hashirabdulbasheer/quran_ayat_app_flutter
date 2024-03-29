import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../../misc/design/design_system.dart';
import '../../../newAyat/data/surah_index.dart';

class QuranAyatDisplaySurahProgressWidget extends StatelessWidget {
  final NQSurahTitle? currentlySelectedSurah;
  final SurahIndex currentIndex;

  const QuranAyatDisplaySurahProgressWidget({
    Key? key,
    required this.currentlySelectedSurah,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NQSurahTitle? surah = currentlySelectedSurah;
    if (surah != null) {
      int totalAyas = surah.totalVerses - 1;
      double progress = currentIndex.aya / totalAyas;

      return Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        child: LinearProgressIndicator(
          backgroundColor: Colors.black12,
          color: QuranDS.appBarBackground,
          value: progress,
        ),
      );
    }

    return Container();
  }
}
