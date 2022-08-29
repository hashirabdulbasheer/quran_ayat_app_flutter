import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../utils/utils.dart';
import '../../data/audio_cache_repository.dart';

class QuranAudioCacheManager {
  final String _reciter = "khalefa_al_tunaiji_64kbps";

  final String _baseAudioUrl = "http://www.everyayah.com/data";

  final QuranAudioCacheRepository _audioRepository =
      QuranAudioCacheRepositoryImpl();

  QuranAudioCacheManager._privateConstructor();

  static final QuranAudioCacheManager instance =
      QuranAudioCacheManager._privateConstructor();

  Future<AudioSource> getSource(int surahIndex, int ayaIndex) async {
    // Uint8List? savedAudio = await _audioRepository.getAudio(surahIndex, ayaIndex, _reciter);
    // if (savedAudio == null) {
    //   // no saved audio
    //   // play live
    //   return AudioSource.uri(Uri.parse(QuranUtils.getAudioUrl(_baseAudioUrl, _reciter, surahIndex, ayaIndex)));
    // }
    // return QuranAudioCacheSource(savedAudio);
    if(surahIndex == 4 && ayaIndex == 5) {
      // TODO: for testing - remove
      //https://github.com/hashirabdulbasheer/my_assets/blob/master/audio/001002.mp3?raw=true
      return AudioSource.uri(Uri.parse("https://github.com/hashirabdulbasheer/my_assets/blob/master/audio/001002.mp3?raw=true"));
    }
    return AudioSource.uri(Uri.parse(QuranUtils.getAudioUrl(_baseAudioUrl, _reciter, surahIndex, ayaIndex)));
  }
}
