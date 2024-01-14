import '../../../utils/utils.dart';
import '../../core/data/quran_firebase_engine.dart';
import '../data/quran_challenges_impl.dart';
import 'models/quran_answer.dart';
import 'models/quran_question.dart';

class QuranChallengeManager {
  static final QuranChallengeManager instance =
      QuranChallengeManager._privateConstructor();

  QuranChallengeManager._privateConstructor();

  final QuranChallengesEngine _challengesEngine =
      QuranChallengesEngine(dataSource: QuranFirebaseEngine.instance);

  Future<void> initialize() async {
    if (await isOffline()) {
      /// OFFLINE
      return;
    }

    /// ONLINE
    return _challengesEngine.initialize();
  }

  Future<List<QuranQuestion>> fetchQuestions() async {
    if (await isOffline()) {
      /// OFFLINE
      return [];
    }

    return await _challengesEngine.fetchQuestions();
  }

  Future<bool> submitAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  ) async {
    if (await isOffline()) {
      /// OFFLINE
      return false;
    }

    return await _challengesEngine.submitAnswer(
      userId,
      questionId,
      answer,
    );
  }

  Future<bool> editAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  ) async {
    if (await isOffline()) {
      /// OFFLINE
      return false;
    }

    return await _challengesEngine.editAnswer(
      userId,
      questionId,
      answer,
    );
  }

  Future<bool> deleteAnswer(
    String userId,
    int questionId,
    QuranAnswer answer,
  ) async {
    if (await isOffline()) {
      /// OFFLINE
      return false;
    }

    return await _challengesEngine.deleteAnswer(
      userId,
      questionId,
      answer,
    );
  }

  Future<bool> isOffline() async {
    return QuranUtils.isOffline();
  }

  String formattedDate(int timeMs) {
    return QuranUtils.formattedDate(timeMs);
  }
}
