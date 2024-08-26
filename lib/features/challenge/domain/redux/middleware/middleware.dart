import 'package:quran_ayat/features/settings/domain/settings_manager.dart';
import 'package:redux/redux.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../challenge_manager.dart';
import '../../models/quran_answer.dart';
import '../../models/quran_question.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createChallengeScreenMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeChallengeScreenAction>(
      _initializeMiddleware,
    ).call,
    TypedMiddleware<AppState, LikeAnswerAction>(
      _likeAnswerMiddleware,
    ).call,
    TypedMiddleware<AppState, UnlikeAnswerAction>(
      _unlikeAnswerMiddleware,
    ).call,
  ];
}

void _initializeMiddleware(
  Store<AppState> _,
  InitializeChallengeScreenAction action,
  NextDispatcher next,
) async {
  bool isEnabled =
      await QuranSettingsManager.instance.isChallengesFeatureEnabled();
  if (isEnabled) {
    // only fetch questions and details if challenge is enabled
    List<QuranQuestion> questions =
        await QuranChallengeManager.instance.fetchQuestions();
    questions.sort((
      a,
      b,
    ) =>
        a.createdOn.compareTo(b.createdOn));
    action = InitializeChallengeScreenAction(questions: questions);
  }
  next(action);
}

void _likeAnswerMiddleware(
  Store<AppState> store,
  LikeAnswerAction action,
  NextDispatcher next,
) async {
  QuranUser? user = QuranAuthFactory.engine.getUser();
  String userId = user?.uid ?? "";
  if (userId.isEmpty || userId == action.answer.userId) {
    /// if current user is the creator of the answer then do not like
    next(action);

    return;
  }
  Set<String> likedUsers = action.answer.likedUsers.toSet();
  likedUsers.add(userId);
  QuranAnswer answer = action.answer.copyWith(likedUsers: likedUsers.toList());
  await QuranChallengeManager.instance.editAnswer(
    userId,
    action.questionId,
    answer,
  );
  store.dispatch(InitializeChallengeScreenAction(questions: const []));
  action = LikeAnswerAction(
    questionId: action.questionId,
    answer: answer,
  );
  next(action);
}

void _unlikeAnswerMiddleware(
  Store<AppState> store,
  UnlikeAnswerAction action,
  NextDispatcher next,
) async {
  QuranUser? user = QuranAuthFactory.engine.getUser();
  String userId = user?.uid ?? "";
  if (userId.isEmpty) {
    next(action);

    return;
  }
  List<String> likedUsers = action.answer.likedUsers;
  likedUsers.remove(userId);
  QuranAnswer answer = action.answer.copyWith(likedUsers: likedUsers);
  await QuranChallengeManager.instance.editAnswer(
    userId,
    action.questionId,
    answer,
  );
  store.dispatch(InitializeChallengeScreenAction(questions: const []));
  action = UnlikeAnswerAction(
    questionId: action.questionId,
    answer: answer,
  );
  next(action);
}
