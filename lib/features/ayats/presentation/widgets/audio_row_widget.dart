import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/audio/audio_cache_manager.dart';

class QuranAudioRowWidget extends StatefulWidget {
  final int surahIndex;
  final int ayaIndex;

  const QuranAudioRowWidget(
      {Key? key, required this.surahIndex, required this.ayaIndex})
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
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () async {
                    AudioSource source = await QuranAudioCacheManager.instance.getSource(widget.surahIndex, widget.ayaIndex);
                    if(source is UriAudioSource) {
                      bool offline = await _isOffline();
                      if (offline) {
                        _showMessage("Unable to connect to the internet 😞");
                        return;
                      }
                    }
                    await _player.setAudioSource(source);
                    await _player.play();
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
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    if (_player.playing) {
                      _player.stop();
                    }
                  },
                  child: const Text("Stop")),
            ),
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
      }
    }
  }

  ///
  /// Utils
  ///

  Future<bool> _isOffline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.bluetooth ||
        connectivityResult == ConnectivityResult.ethernet) {
      return false;
    }
    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
