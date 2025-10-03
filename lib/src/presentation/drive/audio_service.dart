import 'package:ayat_app/src/domain/models/domain_models.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noble_quran/noble_quran.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final VoidCallback onAudioStatusChanged;
  late QuranReciter _reciter;

  AudioService({required this.onAudioStatusChanged}) {
    _player.playerStateStream.listen(_audioStateChanged);
    _reciter = NobleQuran.getAllReciters()
        .firstWhere((r) => r.name.startsWith("MultiLanguage/Basfar Walk"));
  }

  bool get isPlaying => _player.playing;

  Future<void> dispose() async {
    await _player.dispose();
  }

  Future<bool> play({String? audioUrl, Uint8List? audioBytes}) async {
    if (_player.playing) return false;
    if (audioBytes != null && audioBytes.isNotEmpty) {
      return _playBytes(audioBytes);
    } else if (audioUrl != null && audioUrl.isNotEmpty) {
      return _playUrl(audioUrl);
    }
    throw ("Unknown audio source");
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<bool> _playUrl(String? audioUrl) async {
    try {
      if (audioUrl == null) return false;

      await _player.setUrl(audioUrl);
      await _player.play();
      return true;
    } catch (_) {}

    return false;
  }

  Future<bool> _playBytes(Uint8List? audioBytes) async {
    try {
      if (audioBytes == null || audioBytes.isEmpty) {
        return false;
      }

      await _player.setAudioSource(MyCustomSource(audioBytes.toList()));
      await _player.play();
      return true;
    } catch (_) {}

    return false;
  }

  void _audioStateChanged(PlayerState state) {
    if (state.processingState == ProcessingState.completed) {
      _player.stop();
    }
    onAudioStatusChanged();
  }

  String getAudioUrl(SurahIndex index) {
    return NobleQuran.audioRecitationUrl(
      _reciter,
      index.human.sura,
      index.human.aya,
    );
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
