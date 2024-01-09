import '../models/quran_answer.dart';
import '../models/quran_question.dart';

abstract class QuranChallengesDataSource {
  Future<void> initialize();

  Future<List<QuranQuestion>> fetchQuestions();

  Future<QuranQuestion?> fetchQuestion(int questionId);

  Future<bool> submitAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  );

  Future<bool> editAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  );

  Future<bool> deleteAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  );
}
