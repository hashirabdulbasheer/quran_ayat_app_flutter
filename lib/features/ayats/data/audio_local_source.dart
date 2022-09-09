import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'interface/audio_data_source.dart';

class QuranAudioLocalSource implements QuranAudioDataSource {
  @override
  Future<Uint8List?> getAudio(
    int surahIndex,
    int ayaIndex,
    String reciter,
  ) async {
    final String key = "$reciter/$surahIndex/$ayaIndex";
    final prefs = await SharedPreferences.getInstance();
    String? encoded = prefs.getString(key);
    if (encoded != null) {
      Uint8List decoded = base64Decode(encoded);

      return decoded;
    }

    return null;
  }

  @override
  void saveAudio(
    int surahIndex,
    int ayaIndex,
    String reciter,
    Uint8List audioBytes,
  ) async {
    final String key = "$reciter/$surahIndex/$ayaIndex";
    final prefs = await SharedPreferences.getInstance();
    String encoded = base64Encode(audioBytes);
    await prefs.setString(
      key,
      encoded,
    );
  }
}
