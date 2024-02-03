import '../../../../core/domain/app_state/redux/actions/actions.dart';
import '../../../../home/presentation/quran_home_screen.dart';
import '../../models/quran_answer.dart';
import '../../models/quran_question.dart';

class InitializeChallengeScreenAction extends AppStateAction {
  final List<QuranQuestion> questions;

  InitializeChallengeScreenAction({required this.questions});

  @override
  String toString() {
    return '{action: ${super.toString()}, questions: ${questions.length}';
  }
}

class NextChallengeScreenAction extends AppStateAction {}

class PreviousChallengeScreenAction extends AppStateAction {}

class ToggleLoadingScreenAction extends AppStateAction {}

class SelectHomeScreenTabAction extends AppStateAction {
  final QuranHomeScreenBottomTabsEnum tab;

  SelectHomeScreenTabAction({required this.tab});

  @override
  String toString() {
    String tabString =
        tab == QuranHomeScreenBottomTabsEnum.reader ? "reader" : "challenge";

    return '{action: ${super.toString()}, questions: $tabString';
  }
}

class LikeAnswerAction extends AppStateAction {
  final int questionId;
  final QuranAnswer answer;

  LikeAnswerAction({
    required this.questionId,
    required this.answer,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, questionId: $questionId, answerId: ${answer.id}';
  }
}

class UnlikeAnswerAction extends AppStateAction {
  final int questionId;
  final QuranAnswer answer;

  UnlikeAnswerAction({
    required this.questionId,
    required this.answer,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, questionId: $questionId, answerId: ${answer.id}';
  }
}

class SelectCurrentQuestionAction extends AppStateAction {
  final int questionId;

  SelectCurrentQuestionAction({
    required this.questionId,
  });

  @override
  String toString() {
    return '{action: ${super.toString()}, questionId: $questionId';
  }
}
