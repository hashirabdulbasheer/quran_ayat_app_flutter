import 'package:intl/intl.dart' as intl;

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

  Future<QuranQuestion?> fetchQuestion(int questionId) async {
    if (await isOffline()) {
      /// OFFLINE
      return null;
    }

    return await _challengesEngine.fetchQuestion(questionId);
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
    DateTime now = DateTime.now();
    DateTime justNow = DateTime.now().subtract(const Duration(minutes: 1));
    var millis = DateTime.fromMillisecondsSinceEpoch(timeMs);
    if (!millis.difference(justNow).isNegative) {
      return 'Just now';
    }
    if (millis.day == now.day &&
        millis.month == now.month &&
        millis.year == now.year) {
      return intl.DateFormat('jm').format(now);
    }
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (millis.day == yesterday.day &&
        millis.month == yesterday.month &&
        millis.year == yesterday.year) {
      return 'Yesterday, ${intl.DateFormat('jm').format(now)}';
    }
    if (now.difference(millis).inDays < 4) {
      String weekday = intl.DateFormat('EEEE').format(millis);

      return '$weekday, ${intl.DateFormat('jm').format(now)}';
    }
    var d24 = intl.DateFormat('dd/MM/yyyy HH:mm').format(millis);

    return d24;
  }
}
