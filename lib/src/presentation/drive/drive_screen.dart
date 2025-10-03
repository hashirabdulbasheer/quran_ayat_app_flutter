import 'dart:convert';

import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/presentation/home/home.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late HomeBloc _bloc;
  late QuranReciter _reciter;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _bloc = context.read<HomeBloc>();
    _player.playerStateStream.listen(_audioStateChanged);
    _currentIndex = widget.index;
    _reciter = NobleQuran.getAllReciters()
        .firstWhere((r) => r.name.startsWith("MultiLanguage/Basfar Walk"));
  }

  @override
  Widget build(BuildContext context) {
    return QBaseScreen(
        title: "Drive Mode",
        navBarActions: [
          IconButton(
            tooltip: "Bookmark this verse",
            onPressed: onBookmarked,
            icon: isBookmarked
                ? Icon(
                    Icons.bookmark,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.bookmark_border_outlined,
                    size: 24,
                    color: Theme.of(context).disabledColor,
                  ),
          )
        ],
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

  Widget get _titleWidget => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _surahName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              if (_player.playing) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(),
                ),
              ],
              Text(
                "${_currentIndex.human.sura}:${_currentIndex.human.aya}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ].spacerDirectional(width: 8),
          ),
        ],
      );

  Widget get _playAgainWidget => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: ElevatedButton(
            onPressed: () => _player.playing ? _stop() : _play(),
            child: _player.playing
                ? const Text("Stop", style: TextStyle(fontSize: 20))
                : const Text("Play", style: TextStyle(fontSize: 20)),
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
              onPressed: _previous,
              child: const Text("Previous", style: TextStyle(fontSize: 20)),
            )),
            Expanded(
                child: ElevatedButton(
              onPressed: _next,
              child: const Text("Next", style: TextStyle(fontSize: 20)),
            )),
          ].spacerDirectional(width: 10),
        ),
      );

  /// Bookmark
  ///
  void onBookmarked() {
    _bloc.add(AddBookmarkEvent(index: _currentIndex));
    _showMessage("Bookmark saved");
    setState(() {});
  }

  bool get isBookmarked => _isBookmarked(
        _currentIndex,
        (_bloc.state as HomeLoadedState).bookmarkIndex,
      );

  bool _isBookmarked(SurahIndex current, SurahIndex? bookmark) {
    return current == bookmark;
  }

  void _showMessage(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Utils
  ///
  Future<bool> _play() async {
    try {
      if (_player.playing) return false;

      final audioUrl = NobleQuran.audioRecitationUrl(
        _reciter,
        _currentIndex.human.sura,
        _currentIndex.human.aya,
      );

      final bytes = await _audioBytes(_currentIndex, audioUrl);
      if (bytes != null && bytes.isNotEmpty) {
        await _player.setAudioSource(MyCustomSource(bytes.toList()));
        await _player.play();
        return true;
      }
    } catch (e) {
      _showMessage("Error playing audio. Tap Play to try again.");
    }
    return false;
  }

  Future<void> _stop() async {
    await _player.stop();
  }

  void _next() {
    if (_player.playing) return;

    if (_bloc.state is! HomeLoadedState) return;

    final state = _bloc.state as HomeLoadedState;
    final surahTitle = state.suraTitles?[_currentIndex.sura];
    if (surahTitle == null) return;

    final nextIndex = _currentIndex.next(1);
    if (nextIndex.aya >= surahTitle.totalVerses) {
      _showMessage("End of chapter reached");
      return;
    }
    ;

    setState(() {
      _currentIndex = nextIndex;
    });

    _play();

    _bloc.add(HomeSelectSuraAyaEvent(index: _currentIndex));
  }

  void _previous() {
    if (_player.playing) return;

    if (_bloc.state is! HomeLoadedState) return;

    final state = _bloc.state as HomeLoadedState;
    final surahTitle = state.suraTitles?[_currentIndex.sura];
    if (surahTitle == null) return;

    final previousIndex = _currentIndex.previous(1);
    if (previousIndex.aya < 0) {
      _showMessage("You are on the first verse. No more back.");
      return;
    }
    ;

    setState(() {
      _currentIndex = previousIndex;
    });

    _play();

    _bloc.add(HomeSelectSuraAyaEvent(index: _currentIndex));
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

  String get _surahName {
    if (_bloc.state is! HomeLoadedState) return "";

    final state = (_bloc.state as HomeLoadedState);
    if (state.suraTitles?.isEmpty == true) return "";

    final title = state.suraTitles?[_currentIndex.sura];
    if (title == null) return "";
    return "${title.transliterationEn} / ${title.translationEn}";
  }

  /// Cache

  Future<Uint8List?> getCachedAudio(SurahIndex index) async {
    try {
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
    } catch (e) {
      print('Error getting audio from cache: $e');
    }
    return null;
  }

  Future<void> saveAudioToCache(SurahIndex index, Uint8List bytes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String key = "audio_${index.human.sura}_${index.human.aya}";

      String s = base64.encode(bytes);

      await prefs.setString(key, s);
    } catch (e) {
      print('Error saving audio to cache: $e');
    }
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
