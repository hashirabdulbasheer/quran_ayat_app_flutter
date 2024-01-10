import 'package:quran_ayat/features/challenge/domain/enums/quran_answer_status_enum.dart';
import 'package:quran_ayat/features/challenge/domain/enums/quran_question_status_enum.dart';
import 'package:redux/redux.dart';

import '../../../../core/domain/app_state/app_state.dart';
import '../../challenge_manager.dart';
import '../../models/quran_question.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createChallengeScreenMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeChallengeScreenAction>(
      _initializeMiddleware,
    ),
  ];
}

void _initializeMiddleware(
  Store<AppState> store,
  InitializeChallengeScreenAction action,
  NextDispatcher next,
) async {
  List<QuranQuestion> questions =
      await QuranChallengeManager.instance.fetchQuestions();
  // only show open questions that are open and answers that are approved
  questions = questions.where((element) => element.status == QuranQuestionStatusEnum.open).toList();
  for (QuranQuestion question in questions) {
    question.answers.removeWhere((element) => element.status != QuranAnswerStatusEnum.approved);
  }
  action = InitializeChallengeScreenAction(questions: questions);
  next(action);
}
