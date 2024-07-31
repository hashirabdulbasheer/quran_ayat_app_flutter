import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:quran_ayat/features/ai/domain/ai_engine.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';

class GeminiAI implements QuranAIEngine {
  final String apiKey;

  GeminiAI({required this.apiKey});

  @override
  Future<String?> getResponse({
    required SurahIndex currentIndex,
    required String question,
  }) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [Content.text(question)];
    final response = await model.generateContent(content);
    return response.text;
  }
}
