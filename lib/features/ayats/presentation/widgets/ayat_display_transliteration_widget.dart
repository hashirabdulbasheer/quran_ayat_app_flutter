import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../settings/domain/settings_manager.dart';

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
            int? surahIndex = currentlySelectedSurah?.number;
            bool isEnabled = snapshot.data ?? false;
            if (snapshot.hasError || !isEnabled || surahIndex == null) {
              return Container();
            } else {
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
      },
    );
  }
}
