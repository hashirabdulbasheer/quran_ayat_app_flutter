import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../utils/utils.dart';
import '../../domain/audio/audio_cache_manager.dart';

class QuranAudioRowWidget extends StatefulWidget {
  final int surahIndex;
  final int ayaIndex;
  final bool? autoPlayEnabled;
  final Function? onPlayCompleted;
  final Function? onContinuousPlayButtonPressed;
  final Function? onStopButtonPressed;

  const QuranAudioRowWidget(
      {Key? key,
      required this.surahIndex,
      required this.ayaIndex,
      this.autoPlayEnabled,
      this.onContinuousPlayButtonPressed,
      this.onStopButtonPressed,
      this.onPlayCompleted})
      : super(key: key);

  @override
  State<QuranAudioRowWidget> createState() => _QuranAudioRowWidgetState();
}

class _QuranAudioRowWidgetState extends State<QuranAudioRowWidget> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen(_audioStateChanged);
    if (widget.autoPlayEnabled == true) {
      _play();
    }
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
              child: ElevatedButton(
                  onPressed: () async {
                    _play();
                  },
                  child: _player.playing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(color: Colors.white70))
                      : const Text("Play")),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    if (_player.playing) {
                      _player.stop();
                    }
                    if (widget.onStopButtonPressed != null) {
                      widget.onStopButtonPressed!();
                    }
                  },
                  child: const Text("Stop")),
            ),
            // const SizedBox(width: 20),
            // Expanded(
            //   child: ElevatedButton(
            //       onPressed: () {
            //         if (widget.onContinuousPlayButtonPressed != null) {
            //           widget.onContinuousPlayButtonPressed!();
            //         }
            //       },
            //       child: widget.autoPlayEnabled == true
            //           ? const Text("Cont. STOP", textAlign: TextAlign.center)
            //           : const Text("Continuous")),
            // ),
            const SizedBox(width: 5),
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
        if (!state.playing) {
          if (widget.onPlayCompleted != null) {
            widget.onPlayCompleted!();
          }
        }
      }
    }
  }

  void _play() async {
    AudioSource source = await QuranAudioCacheManager.instance
        .getSource(widget.surahIndex, widget.ayaIndex);
    if (source is UriAudioSource) {
      bool offline = await QuranUtils.isOffline();
      if (offline) {
        _showMessage("Unable to connect to the internet 😞");
        return;
      }
    }
    await _player.setAudioSource(source);
    await _player.play();
  }

  ///
  /// Utils
  ///

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
