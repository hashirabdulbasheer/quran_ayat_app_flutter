import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AICache {
  Future<String?> getResponse(SurahIndex currentIndex);

  void saveResponse(SurahIndex currentIndex, String response);
}

/// Simple caching mechanism to store ai response so that it can be reused
class AILocalCache implements AICache {
  @override
  Future<String?> getResponse(SurahIndex currentIndex) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("ai:${currentIndex.toString()}");
  }

  @override
  void saveResponse(SurahIndex currentIndex, String response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("ai:${currentIndex.toString()}", response);
  }
}
