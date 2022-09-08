import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';

import '../../../settings/domain/settings_manager.dart';
import '../../domain/enums/audio_events_enum.dart';
import 'audio_row_widget.dart';

class QuranAyatDisplayAudioControlsWidget extends StatelessWidget {
  final NQSurahTitle? currentlySelectedSurah;
  final int currentlySelectedAya;
  final Function(QuranAudioEventsEnum) onAudioPlayStatusChanged;
  final ValueNotifier<bool> continuousMode;

  const QuranAyatDisplayAudioControlsWidget({
    Key? key,
    required this.currentlySelectedSurah,
    required this.currentlySelectedAya,
    required this.onAudioPlayStatusChanged,
    required this.continuousMode,
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
            if (snapshot.hasError) {
              return Container();
            } else {
              bool isEnabled = snapshot.data as bool;
              if (isEnabled) {
                if (currentlySelectedSurah == null) {
                  return Container();
                }

                return ValueListenableBuilder<bool>(
                  builder: (
                    BuildContext context,
                    bool isContinuousPlay,
                    Widget? child,
                  ) {
                    int? surahIndex = currentlySelectedSurah?.number;
                    if (surahIndex != null) {
                      return QuranAudioRowWidget(
                        isAudioRecitationContinuousPlayEnabled:
                            isContinuousPlay,
                        surahIndex: surahIndex,
                        onAudioEventsListener: onAudioPlayStatusChanged,
                        ayaIndex: currentlySelectedAya,
                      );
                    }

                    return Container();
                  },
                  valueListenable: continuousMode,
                );
              } else {
                return Container();
              }
            }
        }
      },
    );
  }
}
