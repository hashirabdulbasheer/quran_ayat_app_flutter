

import 'dart:convert';

import 'package:ayat_app/src/domain/models/domain_models.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioCacheService {
  /// Cache

  Future<Uint8List?> getCachedAudio(SurahIndex index) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String key = "audio_${index.human.sura}_${index.human.aya}";

      if (!prefs.containsKey(key)) {
        return null;
      }

      String? base64String = prefs.getString(key);
      if (base64String == null) {
        return null;
      }

      return base64.decode(base64String);
    } catch (e) {
      print('Error getting audio from cache: $e');
    }
    return null;
  }

  Future<void> saveAudioToCache(SurahIndex index, Uint8List bytes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String key = "audio_${index.human.sura}_${index.human.aya}";

      String s = base64.encode(bytes);

      await prefs.setString(key, s);
    } catch (e) {
      print('Error saving audio to cache: $e');
    }
  }
}