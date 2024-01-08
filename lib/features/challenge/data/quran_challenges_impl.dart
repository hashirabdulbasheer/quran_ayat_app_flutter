import 'package:quran_ayat/features/challenge/domain/models/quran_answer.dart';
import 'package:quran_ayat/utils/utils.dart';

import '../../../utils/logger_utils.dart';
import '../../core/data/quran_data_interface.dart';
import '../domain/interfaces/quran_challenge_interface.dart';
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
          id: questionMap['id'] as String,
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
    String questionId,
    QuranAnswer answer,
  ) {
    // TODO: implement deleteAnswer
    throw UnimplementedError();
  }

  @override
  Future<bool> editAnswer(
    String userId,
    String questionId,
    QuranAnswer answer,
  ) {
    // TODO: implement editAnswer
    throw UnimplementedError();
  }

  @override
  Future<bool> submitAnswer(
    String userId,
    String questionId,
    QuranAnswer answer,
  ) {
    // TODO: implement submitAnswer
    throw UnimplementedError();
  }
}
