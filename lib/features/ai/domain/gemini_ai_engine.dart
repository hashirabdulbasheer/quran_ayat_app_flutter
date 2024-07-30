import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:quran_ayat/features/ai/domain/ai_engine.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiAI implements QuranAIEngine {
  final String apiKey;

  GeminiAI({required this.apiKey});

  @override
  Future<String?> getResponse({
    required SurahIndex currentIndex,
    required String question,
  }) async {
    String? cachedResponse = await _getCachedResponse(currentIndex);
    if (cachedResponse?.isNotEmpty == true) {
      // present in cache, reuse it
      return cachedResponse;
    }
    // not present in cache, request and save in cache
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text(question)];
      final response = await model.generateContent(content);
      String? responseStr = response.text;
      _saveResponseInCache(currentIndex, responseStr);
      return responseStr;
    } catch (_) {}
    return null;
  }

  ///
  /// Simple caching mechanism to save repeated requests
  ///
  Future<String?> _getCachedResponse(SurahIndex currentIndex) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("ai:${currentIndex.toString()}");
  }

  void _saveResponseInCache(SurahIndex currentIndex, String? response) async {
    if (response == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("ai:${currentIndex.toString()}", response);
  }
}
