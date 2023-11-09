import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/noble_quran.dart';
import '../../../settings/domain/settings_manager.dart';
import 'full_ayat_row_widget.dart';

class QuranAyatDisplayTransliterationWidget extends StatelessWidget {
  final NQSurahTitle? currentlySelectedSurah;
  final int currentlySelectedAya;

  const QuranAyatDisplayTransliterationWidget({
    Key? key,
    required this.currentlySelectedSurah,
    required this.currentlySelectedAya,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: QuranSettingsManager.instance.isTransliterationEnabled(),
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 80,
                child: Center(child: Text('Loading transliteration....')),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Container();
            } else {
              bool isEnabled = snapshot.data as bool;
              if (isEnabled) {
                int? surahIndex = currentlySelectedSurah?.number;
                if (surahIndex != null) {
                  // actual index
                  surahIndex = surahIndex - 1;

                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // QuranFullAyatRowWidget(
                      //   futureMethodThatReturnsSelectedSurah:
                      //       NobleQuran.getSurahTransliteration(
                      //     surahIndex,
                      //   ),
                      //   ayaIndex: currentlySelectedAya,
                      // ),
                    ],
                  );
                }
              }

              return Container();
            }
        }
      },
    );
  }
}
