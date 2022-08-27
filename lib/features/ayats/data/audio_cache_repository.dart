import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'audio_local_source.dart';
import 'audio_network_source.dart';
import 'interface/audio_data_source.dart';

abstract class QuranAudioCacheRepository {
  Future<Uint8List?> getAudio(int surahIndex, int ayaIndex, String reciter);
}

class QuranAudioCacheRepositoryImpl implements QuranAudioCacheRepository {
  final QuranAudioDataSource _localSource = QuranAudioLocalSource();
  final QuranAudioDataSource _remoteSource = QuranAudioNetworkSource();

  @override
  Future<Uint8List?> getAudio(int surahIndex, int ayaIndex, String reciter) async {
    Uint8List? audioBytes = await _localSource.getAudio(surahIndex, ayaIndex, reciter);
    if (audioBytes != null) {
      // from cache
      return audioBytes;
    }
    // not available in cache - fetch remotely
    bool offline = await _isOffline();
    if(!offline) {
      audioBytes = await _remoteSource.getAudio(surahIndex, ayaIndex, reciter);
      if (audioBytes != null) {
        // save in cache using a different isolate
        Map<String, dynamic> params = {
          "surahIndex": surahIndex,
          "ayaIndex": ayaIndex,
          "reciter": reciter,
          "audioBytes": audioBytes
        };
        compute(_saveAudio, params);
      }
    }
    return audioBytes;
  }

  /// Saving locally
  _saveAudio(Map<String, dynamic> params) {
    _localSource.saveAudio(params["surahIndex"],
                      params["ayaIndex"],
                      params["reciter"],
                      params["audioBytes"]);
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

}
