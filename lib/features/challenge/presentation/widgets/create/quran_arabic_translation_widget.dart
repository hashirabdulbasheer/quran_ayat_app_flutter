import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/noble_quran.dart';

import '../../../../ayats/presentation/widgets/ayat_display_translation_widget.dart';
import '../../../../ayats/presentation/widgets/full_ayat_row_widget.dart';
import '../../../../newAyat/data/surah_index.dart';

class QuranArabicTranslationWidget extends StatelessWidget {
  final SurahIndex index;

  const QuranArabicTranslationWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NQSurah>>(
      future: Future.wait([
        NobleQuran.getSurahArabic(
          index.sura,
        ),
        NobleQuran.getTranslationString(
          index.sura,
          NQTranslation.wahiduddinkhan,
        ),
      ]),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<NQSurah>> snapshot,
      ) {
        final surah = snapshot.data;
        if (surah == null || surah.length != 2) {
          return const SizedBox();
        }
        NQSurah arabic = surah.first;
        NQSurah translation = surah[1];

        return Column(
          children: [
            /// ARABIC AYA
            QuranFullAyatRowWidget(
              text: arabic.aya[index.aya].text,
            ),

            /// TRANSLATION OF AYA
            QuranAyatDisplayTranslationWidget(
              translation: translation.aya[index.aya].text,
              translationType: NQTranslation.wahiduddinkhan,
            ),
          ],
        );
      },
    );
  }
}
