
import '../models/quran_answer.dart';
import '../models/quran_question.dart';

abstract class QuranChallengesDataSource {
  Future<void> initialize();

  Future<List<QuranQuestion>> fetchQuestions();

  Future<bool> submitAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  );

  Future<bool> editAnswer(
    String userId,
    String questionId,
    QuranAnswer answer,
  );

  Future<bool> deleteAnswer(
    String userId,
    String questionId,
    QuranAnswer answer,
  );
}
