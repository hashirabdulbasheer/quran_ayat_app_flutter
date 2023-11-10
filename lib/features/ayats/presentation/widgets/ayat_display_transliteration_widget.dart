import 'package:flutter/material.dart';

import '../../../newAyat/data/surah_index.dart';
import '../../../settings/domain/settings_manager.dart';

class QuranAyatDisplayTransliterationWidget extends StatelessWidget {
  final SurahIndex currentIndex;

  const QuranAyatDisplayTransliterationWidget({
    Key? key,
    required this.currentIndex,
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
            bool isEnabled = snapshot.data ?? false;
            if (snapshot.hasError || !isEnabled) {
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
