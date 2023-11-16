import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_ayat/utils/logger_utils.dart';

import '../../../../utils/utils.dart';
import '../../../newAyat/data/surah_index.dart';
import '../../domain/audio/audio_cache_manager.dart';
import '../../domain/enums/audio_events_enum.dart';

class QuranAudioRowWidget extends StatefulWidget {
  final SurahIndex currentIndex;
  final void Function(QuranAudioEventsEnum)? onAudioEventsListener;

  const QuranAudioRowWidget({
    Key? key,
    required this.currentIndex,
    this.onAudioEventsListener,
  }) : super(key: key);

  @override
  State<QuranAudioRowWidget> createState() => _QuranAudioRowWidgetState();
}

class _QuranAudioRowWidgetState extends State<QuranAudioRowWidget> {
  /// the player
  final AudioPlayer _player = AudioPlayer();

  final StreamController<QuranAudioEventsEnum> _audioEventsStream =
      StreamController<QuranAudioEventsEnum>.broadcast();

  @override
  void initState() {
    super.initState();
    _player.playingStream.listen((event) {});
    _player.playerStateStream.listen(_audioStateChanged);
    _audioEventsStream.stream.listen(widget.onAudioEventsListener);
  }

  @override
  void dispose() {
    _player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            Expanded(
              child: Tooltip(
                message: "Play",
                child: ElevatedButton(
                  onPressed: () => _play(),
                  child: _player.playing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white70,
                          ),
                        )
                      : const Icon(Icons.play_arrow_sharp),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Tooltip(
                message: "Stop",
                child: ElevatedButton(
                  onPressed: () => _stop(),
                  child: const Icon(Icons.stop_sharp),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  ///
  ///  Audio Callbacks
  ///

  void _audioStateChanged(PlayerState state) {
    if (mounted) {
      setState(() {});
      if (state.processingState == ProcessingState.completed) {
        _player.stop();
        _audioEventsStream.add(QuranAudioEventsEnum.stopped);
      }
    }
  }

  void _play() async {
    AudioSource source = await QuranAudioCacheManager.instance.getSource(
      widget.currentIndex.human.sura,
      widget.currentIndex.human.aya,
    );
    if (source is UriAudioSource) {
      bool offline = await QuranUtils.isOffline();
      if (offline) {
        _showMessage("Unable to connect to the internet 😞");

        return;
      }
    }
    await _player.setAudioSource(source);
    await _player.play();
    QuranLogger.logAnalytics("media-play");
  }

  void _stop() {
    // stop the current player if playing
    if (_player.playing) {
      _player.stop();
    }
    // inform the main UI of the stopped event
    _audioEventsStream.add(QuranAudioEventsEnum.stopped);
  }

  ///
  /// Utils
  ///

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
