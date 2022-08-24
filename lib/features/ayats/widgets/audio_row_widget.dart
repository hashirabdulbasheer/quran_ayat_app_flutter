import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;


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
  final intl.NumberFormat formatter = intl.NumberFormat("000");

  final String _baseAudioUrl =
      "http://www.everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com";

  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen(_audioStateChanged);
    _player.onPlayerComplete.listen(_audioPlayCompleted);
  }

  @override
  void dispose() {
    _player.stop();
    _player.release();
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
                    bool offline = await _isOffline();
                    if (!offline) {
                      if (_player.state == PlayerState.playing) {
                        _player.stop();
                      }
                      await _player.play(UrlSource(
                          "$_baseAudioUrl/${formatter.format(widget.surahIndex)}${formatter.format(widget.ayaIndex)}.mp3"));
                    } else {
                      _showMessage("Unable to connect to the internet 😞");
                    }
                  },
                  child: _player.state == PlayerState.playing
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
                    if (_player.state == PlayerState.playing) {
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
    }
  }

  void _audioPlayCompleted(event) {
    _player.stop();
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
