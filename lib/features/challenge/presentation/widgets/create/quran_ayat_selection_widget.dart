import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:redux/redux.dart';

import '../../../../../misc/design/design_system.dart';
import '../../../../ayats/presentation/widgets/ayat_display_header_widget.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../newAyat/data/surah_index.dart';

class QuranAyatSelectionWidget extends StatelessWidget {
  final Store<AppState> store;
  final String title;
  final NQSurahTitle currentSurahDetails;
  final SurahIndex currentIndex;
  final Function(NQSurahTitle) onSuraSelected;
  final Function(int) onAyaSelected;

  const QuranAyatSelectionWidget({
    super.key,
    required this.store,
    required this.title,
    required this.currentSurahDetails,
    required this.currentIndex,
    required this.onSuraSelected,
    required this.onAyaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: QuranDS.textTitleMediumLight,
        ),

        const SizedBox(
          height: 5,
        ),

        /// HEADER - AYA SELECTION
        QuranAyatHeaderWidget(
          surahTitles: store.state.reader.surahTitles,
          onSurahSelected: (surah) => onSuraSelected(surah),
          onAyaNumberSelected: (aya) => onAyaSelected(aya),
          currentlySelectedSurah: currentSurahDetails,
          currentIndex: currentIndex,
        ),
      ],
    );
  }
}
