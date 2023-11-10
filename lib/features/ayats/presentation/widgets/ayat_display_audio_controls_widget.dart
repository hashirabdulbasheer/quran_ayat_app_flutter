import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../settings/domain/settings_manager.dart';
import '../../domain/enums/audio_events_enum.dart';
import 'audio_row_widget.dart';

class QuranAyatDisplayAudioControlsWidget extends StatelessWidget {
  final NQSurahTitle? currentlySelectedSurah;
  final int currentlySelectedAya;
  final Function(QuranAudioEventsEnum) onAudioPlayStatusChanged;

  const QuranAyatDisplayAudioControlsWidget({
    Key? key,
    required this.currentlySelectedSurah,
    required this.currentlySelectedAya,
    required this.onAudioPlayStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: QuranSettingsManager.instance.isAudioControlsEnabled(),
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
                child: Center(child: Text('Loading audio ....')),
              ),
            );
          default:
            int? surahIndex = currentlySelectedSurah?.number;
            bool isEnabled = snapshot.data ?? false;
            if (snapshot.hasError ||
                currentlySelectedSurah == null ||
                surahIndex == null ||
                !isEnabled) {
              return Container();
            } else {
              return QuranAudioRowWidget(
                surahIndex: surahIndex,
                onAudioEventsListener: onAudioPlayStatusChanged,
                ayaIndex: currentlySelectedAya,
              );
            }
        }
      },
    );
  }
}
