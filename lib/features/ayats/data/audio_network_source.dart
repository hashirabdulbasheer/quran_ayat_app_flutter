import 'dart:typed_data';

import '../../../misc/configs/app_config.dart';
import '../../../utils/utils.dart';
import 'interface/audio_data_source.dart';
import 'package:http/http.dart' as http;

class QuranAudioNetworkSource implements QuranAudioDataSource {
  @override
  Future<Uint8List> getAudio(
      int surahIndex, int ayaIndex, String reciter,) async {
    String url = QuranUtils.getAudioUrl(
        QuranAppConfig.audioRecitationBaseUrl, reciter, surahIndex, ayaIndex,);
    final response = await http.get(Uri.parse(url));
    Uint8List bytes = response.bodyBytes;

    return bytes;
  }

  @override
  void saveAudio(
      int surahIndex, int ayaIndex, String reciter, Uint8List audioBytes,) {
    throw UnimplementedError("Not Implemented");
  }
}
