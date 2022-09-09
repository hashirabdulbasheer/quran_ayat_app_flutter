import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/noble_quran.dart';
import '../../../../misc/enums/quran_font_family_enum.dart';
import '../../../settings/domain/settings_manager.dart';
import 'full_ayat_row_widget.dart';

class QuranAyatDisplayTranslationWidget extends StatelessWidget {
  final NQSurahTitle? currentlySelectedSurah;
  final int currentlySelectedAya;

  const QuranAyatDisplayTranslationWidget({
    Key? key,
    required this.currentlySelectedSurah,
    required this.currentlySelectedAya,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NQTranslation>(
      future: QuranSettingsManager.instance.getTranslation(),
      builder: (
        BuildContext context,
        AsyncSnapshot<NQTranslation> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 80,
                child: Center(child: Text('Loading translation....')),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Container();
            } else {
              NQTranslation translation = snapshot.data as NQTranslation;
              int? surahIndex = currentlySelectedSurah?.number;
              if (surahIndex != null) {
                // actual index
                surahIndex = surahIndex - 1;

                return Column(children: [
                  const SizedBox(height: 20),
                  QuranFullAyatRowWidget(
                    futureMethodThatReturnsSelectedSurah:
                        NobleQuran.getTranslationString(
                      surahIndex,
                      translation,
                    ),
                    fontFamily: _translationFontFamily(translation),
                    ayaIndex: currentlySelectedAya,
                  ),
                ]);
              }

              return Container();
            }
        }
      },
    );
  }

  /// special font handling for translations
  String? _translationFontFamily(NQTranslation translation) {
    if (translation == NQTranslation.malayalam_karakunnu ||
        translation == NQTranslation.malayalam_abdulhameed) {
      return QuranFontFamily.malayalam.rawString;
    }

    return null;
  }
}
