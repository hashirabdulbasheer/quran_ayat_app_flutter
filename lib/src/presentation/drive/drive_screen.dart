import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/presentation/home/home.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:html' as html;


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
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
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
            onPressed: () => _isPlaying ? _stop() : _play(),
            child: _isPlaying
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
    Duration? duration;
    try {
      if (_isPlaying) return;

      setState(() {
        _isPlaying = true;
      });

      final audioUrl = NobleQuran.audioRecitationUrl(
        _reciter,
        _currentIndex.human.sura,
        _currentIndex.human.aya,
      );

      duration = await _player.setUrl(audioUrl) ?? const Duration(seconds: 1);
      duration = const Duration(seconds: 1) + duration;
      Future.delayed(duration, () {
        setState(() {
          _isPlaying = false;
        });
      });

      await _player.play();
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _stop() async {
    await _player.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _next() async {
    if (_isPlaying) return;
    setState(() {
      _currentIndex = _currentIndex.next(1);
    });
    updateUrl();
    await _play();
  }

  Future<void> _previous() async {
    if (_isPlaying) return;
    setState(() {
      _currentIndex = _currentIndex.previous(1);
    });
    updateUrl();
    await _play();
  }

  void updateUrl() {
    try {
      final currentPath = html.window.location.pathname;
      if(currentPath == null) return;

      final pathSegments = currentPath.split('/').where((s) => s.isNotEmpty).toList();
      
      if (pathSegments.isNotEmpty == true) {
        // Update the last segment with the current aya index
        pathSegments[pathSegments.length - 1] = _currentIndex.human.aya.toString();
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
}
