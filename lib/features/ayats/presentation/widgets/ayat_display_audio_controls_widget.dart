import 'package:flutter/material.dart';

import '../../../newAyat/data/surah_index.dart';
import '../../../settings/domain/settings_manager.dart';
import '../../domain/enums/audio_events_enum.dart';
import 'audio_row_widget.dart';

class QuranAyatDisplayAudioControlsWidget extends StatelessWidget {
  final SurahIndex currentIndex;
  final Function(QuranAudioEventsEnum) onAudioPlayStatusChanged;

  const QuranAyatDisplayAudioControlsWidget({
    Key? key,
    required this.currentIndex,
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
            bool isEnabled = snapshot.data ?? false;
            if (snapshot.hasError || !isEnabled) {
              return Container();
            } else {
              return QuranAudioRowWidget(
                currentIndex: currentIndex,
                onAudioEventsListener: onAudioPlayStatusChanged,
              );
            }
        }
      },
    );
  }
}
