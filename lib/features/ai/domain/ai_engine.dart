import 'package:quran_ayat/features/newAyat/data/surah_index.dart';

abstract class QuranAIEngine {
  Future<String?> getResponse({
    required SurahIndex currentIndex,
    required String question,
  });
}
