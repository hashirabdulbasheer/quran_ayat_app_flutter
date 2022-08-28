import 'package:flutter/foundation.dart';

abstract class QuranAudioDataSource {
  void saveAudio(int surahIndex, int ayaIndex, String reciter, Uint8List audioBytes);
  Future<Uint8List?> getAudio(int surahIndex, int ayaIndex, String reciter);
}
