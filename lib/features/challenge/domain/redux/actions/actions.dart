import '../../../../core/domain/app_state/redux/actions/actions.dart';
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
