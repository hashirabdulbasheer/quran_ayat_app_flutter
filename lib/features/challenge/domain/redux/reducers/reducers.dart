import 'package:redux/redux.dart';

import '../../enums/quran_answer_status_enum.dart';
import '../../enums/quran_question_status_enum.dart';
import '../../models/quran_question.dart';
import '../actions/actions.dart';
import '../challenge_screen_state.dart';

Reducer<ChallengeScreenState> challengeScreenReducer =
    combineReducers<ChallengeScreenState>([
  TypedReducer<ChallengeScreenState, InitializeChallengeScreenAction>(
    _initializeChallengeScreenReducer,
  ),
  TypedReducer<ChallengeScreenState, NextChallengeScreenAction>(
    _nextChallengeScreenReducer,
  ),
  TypedReducer<ChallengeScreenState, PreviousChallengeScreenAction>(
    _previousChallengeScreenReducer,
  ),
  TypedReducer<ChallengeScreenState, ToggleLoadingScreenAction>(
    _toggleLoadingScreenReducer,
  ),
]);

ChallengeScreenState _initializeChallengeScreenReducer(
  ChallengeScreenState state,
  InitializeChallengeScreenAction action,
) {
  // filtered = only show open questions that are open and answers that are approved
  List<QuranQuestion> filteredQuestions = [];
  filteredQuestions = action.questions
      .where((element) => element.status == QuranQuestionStatusEnum.open)
      .toList();
  for (QuranQuestion question in filteredQuestions) {
    question.answers.removeWhere(
      (element) => element.status != QuranAnswerStatusEnum.approved,
    );
  }

  return state.copyWith(
    allQuestions: action.questions,
    filteredQuestions: filteredQuestions,
  );
}

ChallengeScreenState _nextChallengeScreenReducer(
  ChallengeScreenState state,
  NextChallengeScreenAction action,
) {
  int nextIndex = state.currentIndex + 1;
  if (nextIndex < state.filteredQuestions.length) {
    return state.copyWith(currentIndex: nextIndex);
  }

  return state;
}

ChallengeScreenState _previousChallengeScreenReducer(
  ChallengeScreenState state,
  PreviousChallengeScreenAction action,
) {
  int previousIndex = state.currentIndex - 1;
  if (previousIndex >= 0) {
    return state.copyWith(currentIndex: previousIndex);
  }

  return state;
}

ChallengeScreenState _toggleLoadingScreenReducer(
  ChallengeScreenState state,
  ToggleLoadingScreenAction action,
) {
  return state.copyWith(isLoading: !state.isLoading);
}
