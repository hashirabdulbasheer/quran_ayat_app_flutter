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
  questions.sort((a,b,) => b.createdOn.compareTo(a.createdOn));
  action = InitializeChallengeScreenAction(questions: questions);
  next(action);
}
