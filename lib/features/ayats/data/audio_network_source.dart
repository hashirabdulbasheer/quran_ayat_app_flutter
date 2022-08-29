import 'dart:typed_data';

import 'interface/audio_data_source.dart';
import 'package:http/http.dart' as http;


class QuranAudioNetworkSource implements QuranAudioDataSource {
  final String _baseAudioUrl = "http://www.everyayah.com/data";

  @override
  Future<Uint8List> getAudio(
      int surahIndex, int ayaIndex, String reciter) async {
    // String url =
    //     QuranUtils.getAudioUrl(_baseAudioUrl, reciter, surahIndex, ayaIndex);
    String url = "https://uxquran.com/audio/001002.mp3";
    final response = await http.get(Uri.parse(url));
    Uint8List bytes = response.bodyBytes;
    return bytes;
  }

  @override
  void saveAudio(
      int surahIndex, int ayaIndex, String reciter, Uint8List audioBytes) {
    throw UnimplementedError("Not Implemented");
  }
}
