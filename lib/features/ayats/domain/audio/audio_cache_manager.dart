import 'package:just_audio/just_audio.dart';
import 'package:quran_ayat/features/settings/domain/settings_manager.dart';
import '../../../../misc/configs/app_config.dart';
import '../../../../utils/utils.dart';

class QuranAudioCacheManager {
  // final QuranAudioCacheRepository _audioRepository =
  //     QuranAudioCacheRepositoryImpl();

  QuranAudioCacheManager._privateConstructor();

  static final QuranAudioCacheManager instance =
      QuranAudioCacheManager._privateConstructor();

  Future<AudioSource> getSource(
    int surahIndex,
    int ayaIndex,
  ) async {
    // TODO: Find a way to use cache audio later
    // Uint8List? savedAudio = await _audioRepository.getAudio(surahIndex, ayaIndex, _reciter);
    // if (savedAudio == null) {
    //   // no saved audio
    //   // play live
    //   return AudioSource.uri(Uri.parse(QuranUtils.getAudioUrl(_baseAudioUrl, _reciter, surahIndex, ayaIndex)));
    // }
    // return QuranAudioCacheSource(savedAudio);
    String reciter = await QuranSettingsManager.instance.getReciterKey();

    return AudioSource.uri(Uri.parse(QuranUtils.getAudioUrl(
      QuranAppConfig.audioRecitationBaseUrl,
      reciter,
      surahIndex,
      ayaIndex,
    )));
  }
}
