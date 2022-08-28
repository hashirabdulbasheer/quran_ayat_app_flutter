import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../utils/utils.dart';
import '../../data/audio_cache_repository.dart';
import 'quran_audio_cache_source.dart';

class QuranAudioCacheManager {
  final String _reciter = "khalefa_al_tunaiji_64kbps";

  final String _baseAudioUrl = "http://www.everyayah.com/data";

  final QuranAudioCacheRepository _audioRepository =
      QuranAudioCacheRepositoryImpl();

  QuranAudioCacheManager._privateConstructor();

  static final QuranAudioCacheManager instance =
      QuranAudioCacheManager._privateConstructor();

  Future<AudioSource> getSource(int surahIndex, int ayaIndex) async {
    Uint8List? savedAudio = await _audioRepository.getAudio(surahIndex, ayaIndex, _reciter);
    if (savedAudio == null) {
      // no saved audio
      // play live
      return AudioSource.uri(Uri.parse(QuranUtils.getAudioUrl(_baseAudioUrl, _reciter, surahIndex, ayaIndex)));
    }
    return QuranAudioCacheSource(savedAudio);
  }
}
