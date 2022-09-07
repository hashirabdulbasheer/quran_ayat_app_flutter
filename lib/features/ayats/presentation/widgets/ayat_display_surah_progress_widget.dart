import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

class QuranAyatDisplaySurahProgressWidget extends StatelessWidget {

  final NQSurahTitle? currentlySelectedSurah;
  final int? currentlySelectedAya;

  const QuranAyatDisplaySurahProgressWidget(
      {Key? key, required this.currentlySelectedSurah, required this.currentlySelectedAya,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NQSurahTitle? surah = currentlySelectedSurah;
    if (surah != null) {
      int totalAyas = surah.totalVerses;
      int currentAya = currentlySelectedAya ?? 1;
      double progress = currentAya / totalAyas;

      return Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        child: LinearProgressIndicator(
          backgroundColor: Colors.black12,
          value: progress,
        ),
      );
    }

    return Container();
  }
}
