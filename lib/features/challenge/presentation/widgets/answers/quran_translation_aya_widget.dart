import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/noble_quran.dart';

import '../../../../../misc/design/design_system.dart';
import '../../../../newAyat/data/surah_index.dart';

class QuranTranslationForAyaWidget extends StatelessWidget {
  final SurahIndex index;

  const QuranTranslationForAyaWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NQSurah>(
      future: NobleQuran.getTranslationString(
        index.sura,
        NQTranslation.wahiduddinkhan,
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot<NQSurah> snapshot,
      ) {
        if (snapshot.hasData &&
            (snapshot.data as NQSurah).aya.length >= index.aya) {
          NQSurah surah = snapshot.data as NQSurah;
          NQAyat aya = surah.aya[index.aya];
          String ayaText = aya.text.length > 300
              ? "${aya.text.substring(
                  0,
                  300,
                )}..."
              : aya.text;

          return Text(
            "${index.sura + 1}:${index.aya + 1} $ayaText",
            style: QuranDS.textTitleMediumItalic,
          );
        }

        return Container();
      },
    );
  }
}
