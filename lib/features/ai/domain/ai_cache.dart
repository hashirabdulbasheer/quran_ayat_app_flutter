import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_type_enum.dart';

abstract class AICache {
  Future<String?> getResponse({
    required SurahIndex index,
    required QuranAIType type,
  });

  void saveResponse({
    required SurahIndex index,
    required QuranAIType type,
    required String response,
  });

  void removeResponse({
    required SurahIndex index,
    required QuranAIType type,
  });
}

/// Simple caching mechanism to store ai response so that it can be reused
class AILocalCache implements AICache {
  @override
  Future<String?> getResponse({
    required SurahIndex index,
    required QuranAIType type,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("ai:${type.toString()}:${index.toString()}");
  }

  @override
  void saveResponse({
    required SurahIndex index,
    required QuranAIType type,
    required String response,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "ai:${type.toString()}:${index.toString()}", response);
  }

  @override
  void removeResponse({
    required SurahIndex index,
    required QuranAIType type,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("ai:${type.toString()}:${index.toString()}");
  }
}
