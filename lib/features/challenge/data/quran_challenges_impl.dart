import '../../../utils/logger_utils.dart';
import '../../../utils/utils.dart';
import '../../core/data/quran_data_interface.dart';
import '../domain/interfaces/quran_challenge_interface.dart';
import '../domain/models/quran_answer.dart';
import '../domain/models/quran_question.dart';

class QuranChallengesEngine implements QuranChallengesDataSource {
  final QuranDataSource dataSource;

  QuranChallengesEngine({required this.dataSource});

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<List<QuranQuestion>> fetchQuestions() async {
    List<QuranQuestion> questions = [];
    try {
      dynamic resultList = await dataSource.fetchAll("questions");
      if (resultList == null) {
        return [];
      }
      for (Map<String, dynamic> questionMap in resultList) {
        QuranQuestion question = QuranQuestion(
          id: questionMap['id'] as int,
          title: questionMap['title'] as String,
          question: questionMap['question'] as String,
          answers: questionMap["answers"] != null
              ? (questionMap["answers"] as List<dynamic>)
                  .map((dynamic e) => QuranAnswer(
                        id: e['id'] as String,
                        surah: e['surah'] as int,
                        aya: e['aya'] as int,
                        userId: e['userId'] as String,
                        username: e['username'] as String,
                        note: e['note'] as String,
                        createdOn: e['createdOn'] as int,
                        status: QuranUtils.answerStatusFromString(
                          e['status'] as String,
                        ),
                      ))
                  .toList()
              : [],
          status: QuranUtils.questionStatusFromString(
            questionMap['status'] as String,
          ),
          createdOn: questionMap['createdOn'] as int,
        );
        questions.add(question);
      }
    } catch (error) {
      QuranLogger.logE(
        error,
      );
    }

    return questions;
  }

  @override
  Future<bool> deleteAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  ) async {
    QuranQuestion? question = await _fetchQuestion(questionId);
    if (question == null || answer.id.isEmpty) {
      return false;
    }

    try {
      question.answers.removeWhere((element) => element.id == answer.id);
      await dataSource.update(
        "questions/$questionId",
        question.toMap(),
      );

      return true;
    } catch (e) {
      QuranLogger.logE(e);
    }

    return false;
  }

  @override
  Future<bool> editAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  ) async {
    QuranQuestion? question = await _fetchQuestion(questionId);
    if (question == null || answer.id.isEmpty) {
      return false;
    }

    try {
      // validate that answer id already exists
      // if answer not found then this will throw error
      int answerIndex =
          question.answers.indexWhere((element) => element.id == answer.id);
      if (answerIndex < 0) {
        /// not found

        return false;
      }

      /// found
      await dataSource.update(
        "questions/$questionId/answers/$answerIndex",
        answer.toMap(),
      );

      return true;
    } catch (e) {
      QuranLogger.logE(e);
    }

    return false;
  }

  @override
  Future<bool> submitAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  ) async {
    QuranQuestion? question = await _fetchQuestion(questionId);
    if (question == null) {
      return false;
    }

    try {
      if (question.answers == null || question.answers.isEmpty) {
        question.copyWith(answers: [answer]);
      } else {
        question.answers.add(answer);
      }
      await dataSource.update(
        "questions/$questionId",
        question.toMap(),
      );

      return true;
    } catch (e) {
      QuranLogger.logE(e);
    }

    return false;
  }

  Future<QuranQuestion?> _fetchQuestion(int questionId) async {
    try {
      dynamic resultList = await dataSource.fetch("questions/$questionId");
      if (resultList == null) {
        return null;
      }

      Map<String, dynamic>? questionMap =
          Map<String, dynamic>.from(resultList as Map);

      /// preprocess to remove nulls from firebase
      List<dynamic> answersDyn =
          questionMap["answers"] as List<dynamic>? ?? List<dynamic>.empty();
      for (dynamic item in answersDyn) {
        if (item == null) {
          answersDyn.remove(item);
        }
      }

      // map answers
      List<QuranAnswer> answers = List<QuranAnswer>.empty();
      answers = answersDyn
          .map((dynamic e) => QuranAnswer(
                id: e['id'] as String,
                surah: e['surah'] as int,
                aya: e['aya'] as int,
                userId: e['userId'] as String,
                username: e['username'] as String,
                note: e['note'] as String,
                createdOn: e['createdOn'] as int,
                status: QuranUtils.answerStatusFromString(
                  e['status'] as String,
                ),
              ))
          .toList();

      return QuranQuestion(
        id: questionMap['id'] as int,
        title: questionMap['title'] as String,
        question: questionMap['question'] as String,
        answers: answers,
        status: QuranUtils.questionStatusFromString(
          questionMap['status'] as String,
        ),
        createdOn: questionMap['createdOn'] as int,
      );
    } catch (error) {
      QuranLogger.logE(
        error,
      );
    }

    return null;
  }
}
