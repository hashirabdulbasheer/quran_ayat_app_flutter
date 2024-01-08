class QuranQuestion {}

class QuranAnswer {}

abstract class QuranChallengesDataSource {
  Future<void> initialize();

  Future<List<QuranQuestion>> fetchQuestions(
    String userId,
  );

  Future<bool> submitAnswer(
    String userId,
    String questionId,
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
