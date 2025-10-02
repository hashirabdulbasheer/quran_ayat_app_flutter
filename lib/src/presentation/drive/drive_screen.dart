import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/presentation/home/home.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:wakelock_plus/wakelock_plus.dart';

class DriveScreen extends StatefulWidget {
  final SurahIndex index;

  const DriveScreen({
    super.key,
    required this.index,
  });

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  late SurahIndex _currentIndex;
  late QuranReciter _reciter;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _player.playerStateStream.listen(_audioStateChanged);
    _currentIndex = widget.index;
    _reciter = NobleQuran.getAllReciters()
        .firstWhere((r) => r.name.startsWith("MultiLanguage/Basfar Walk"));
    _play();
  }

  @override
  Widget build(BuildContext context) {
    return QBaseScreen(
        title: "Drive Mode",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _titleWidget,
              Expanded(
                child: _playAgainWidget,
              ),
              _navigationWidget,
            ].spacerDirectional(height: 20),
          ),
        ));
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _player.dispose();
    super.dispose();
  }

  Widget get _titleWidget => Text(
        "${_currentIndex.human.sura}:${_currentIndex.human.aya}",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget get _playAgainWidget => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: ElevatedButton(
            onPressed: () => _player.playing ? _stop() : _play(),
            child: _player.playing
                ? const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : Text(
                    "Play ${_currentIndex.human.sura}:${_currentIndex.human.aya}"),
          )),
        ],
      );

  Widget get _navigationWidget => SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () => _previous(),
              child: const Text("Previous"),
            )),
            Expanded(
                child: ElevatedButton(
              onPressed: () => _next(),
              child: const Text("Next"),
            )),
          ].spacerDirectional(width: 10),
        ),
      );

  /// Utils
  ///
  Future<void> _play() async {
    try {
      if (_player.playing) return;

      final audioUrl = NobleQuran.audioRecitationUrl(
        _reciter,
        _currentIndex.human.sura,
        _currentIndex.human.aya,
      );

      final bytes = await _audioBytes(_currentIndex, audioUrl);
      await _player.setAudioSource(MyCustomSource(bytes!.toList()));
      await _player.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _stop() async {
    await _player.stop();
  }

  Future<void> _next() async {
    if (_player.playing) return;
    setState(() {
      _currentIndex = _currentIndex.next(1);
    });
    updateUrl();
    await _play();
  }

  Future<void> _previous() async {
    if (_player.playing) return;
    setState(() {
      _currentIndex = _currentIndex.previous(1);
    });
    updateUrl();
    await _play();
  }

  /// Called when the player state changes.
  ///
  /// When the player finishes playing an audio file,
  /// this function is called to stop the player.
  ///
  /// [state] is the new player state.
  ///
  /// If the player has finished processing an audio file,
  /// this function calls [_player.stop] to stop the player.
  void _audioStateChanged(PlayerState state) {
    if (mounted) {
      setState(() {});
      if (state.processingState == ProcessingState.completed) {
        _player.stop();
      }
    }
  }

  /// Utils

  void updateUrl() {
    if (!kIsWeb) return;

    try {
      final currentPath = html.window.location.pathname;
      if (currentPath == null) return;

      final pathSegments =
          currentPath.split('/').where((s) => s.isNotEmpty).toList();

      if (pathSegments.isNotEmpty == true) {
        // Update the last segment with the current aya index
        pathSegments[pathSegments.length - 1] =
            _currentIndex.human.aya.toString();
        final newPath = '/${pathSegments.join('/')}';

        // Update the URL without triggering navigation
        html.window.history.replaceState({}, '', newPath);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating URL: $e');
      }
    }
  }

  Future<Uint8List?> _audioBytes(SurahIndex index, String audioUrl) async {
    try {
      // Check if available in cache
      final cachedAudio = await getCachedAudio(index);
      if (cachedAudio != null) {
        return cachedAudio;
      }

      // Download audio from URL
      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        await saveAudioToCache(index, bytes);
        return bytes;
      }
    } catch (e) {
      print('Error saving audio: $e');
    }
    return null;
  }

  /// Cache

  Future<Uint8List?> getCachedAudio(SurahIndex index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String key = "audio_${index.human.sura}_${index.human.aya}";

    if (!prefs.containsKey(key)) {
      return null;
    }

    String? base64String = prefs.getString(key);
    if (base64String == null) {
      return null;
    }

    return base64.decode(base64String);
  }

  Future<void> saveAudioToCache(SurahIndex index, Uint8List bytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String key = "audio_${index.human.sura}_${index.human.aya}";

    String s = base64.encode(bytes);

    await prefs.setString(key, s);
  }
}

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;

  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
