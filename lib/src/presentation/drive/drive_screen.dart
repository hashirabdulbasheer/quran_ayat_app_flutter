import 'package:ayat_app/src/presentation/drive/audio_cache_service.dart';
import 'package:ayat_app/src/presentation/home/home.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';

import 'audio_service.dart';

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
  late AudioService _audioService;
  late AudioCacheService _audioCacheService;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _audioService = AudioService(onAudioStatusChanged: _onAudioStatusChanged);
    _audioCacheService = AudioCacheService();
    _bloc = context.read<HomeBloc>();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return QBaseScreen(
        title: "Drive Mode",
        navBarActions: [
          IconButton(
            tooltip: "Bookmark this verse",
            onPressed: () => onBookmarked(_currentIndex),
            icon: isBookmarked(_currentIndex)
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
    _audioService.dispose();
    super.dispose();
  }

  Widget get _titleWidget => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getSurahName(_currentIndex),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              if (_audioService.isPlaying) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(),
                ),
              ],
              Text(
                _getIndexString(_currentIndex),
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
            onPressed: () => _audioService.isPlaying
                ? _audioService.stop()
                : _playVerse(_currentIndex),
            child: _audioService.isPlaying
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
              onPressed: _gotToPreviousVerse,
              child: const Text("Previous", style: TextStyle(fontSize: 20)),
            )),
            Expanded(
                child: ElevatedButton(
              onPressed: _goToNextVerse,
              child: const Text("Next", style: TextStyle(fontSize: 20)),
            )),
          ].spacerDirectional(width: 10),
        ),
      );

  void _onAudioStatusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Bookmark
  ///
  void onBookmarked(SurahIndex index) {
    _bloc.add(AddBookmarkEvent(index: index));
    _showMessage("Bookmark saved");
    setState(() {});
  }

  bool isBookmarked(SurahIndex index) => _isBookmarked(
        index,
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

  void _goToNextVerse() {
    if (_audioService.isPlaying) return;

    if (_bloc.state is! HomeLoadedState) return;

    final state = _bloc.state as HomeLoadedState;
    final surahTitle = state.suraTitles?[_currentIndex.sura];
    if (surahTitle == null) return;

    final nextIndex = _currentIndex.next(1);
    if (nextIndex.aya >= surahTitle.totalVerses) {
      _showMessage("End of chapter reached");
      return;
    }

    setState(() {
      _currentIndex = nextIndex;
    });

    _playVerse(_currentIndex);

    _bloc.add(HomeSelectSuraAyaEvent(index: _currentIndex));
  }

  void _gotToPreviousVerse() {
    if (_audioService.isPlaying) return;
    if (_bloc.state is! HomeLoadedState) return;

    final previousIndex = _currentIndex.previous(1);
    if (previousIndex.aya < 0) {
      _showMessage("You are on the first verse. No more back.");
      return;
    }

    setState(() {
      _currentIndex = previousIndex;
    });

    _playVerse(_currentIndex);

    _bloc.add(HomeSelectSuraAyaEvent(index: _currentIndex));
  }

  Future<void> _playVerse(SurahIndex index) async {
    try {
      // if there is audio in the cache then play it
      final cachedAudio = await _audioCacheService.getCachedAudio(
        index,
      );
      if (cachedAudio != null && cachedAudio.isNotEmpty) {
        await _audioService.play(audioBytes: cachedAudio);
        return;
      }

      // if there is no audio in the cache play from url
      final audioUrl = _audioService.getAudioUrl(index);
      await _audioService.play(audioUrl: audioUrl);

      // Download audio from URL
      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        await _audioCacheService.saveAudioToCache(index, bytes);
      }
    } catch (_) {
      _showMessage("Error playing audio. Try again.");
    }

    return;
  }

  String _getSurahName(SurahIndex index) {
    if (_bloc.state is! HomeLoadedState) return "";

    final suraTitle = _getSurahTitle(index);
    if (suraTitle == null) return "";

    return "${suraTitle.transliterationEn} / ${suraTitle.translationEn}";
  }

  SuraTitle? _getSurahTitle(SurahIndex index) {
    if (_bloc.state is! HomeLoadedState) return null;

    final state = _bloc.state as HomeLoadedState;
    return state.suraTitles?[index.sura];
  }

  String _getIndexString(SurahIndex index) {
    return "${index.human.sura}:${index.human.aya}";
  }
}
