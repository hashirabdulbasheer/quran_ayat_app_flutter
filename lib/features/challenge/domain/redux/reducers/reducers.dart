import 'package:redux/redux.dart';

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
  TypedReducer<ChallengeScreenState, SelectHomeScreenTabAction>(
    _selectHomeScreenTabReducer,
  ),
  TypedReducer<ChallengeScreenState, LikeAnswerAction>(
    _likeActionReducer,
  ),
  TypedReducer<ChallengeScreenState, UnlikeAnswerAction>(
    _unlikeActionReducer,
  ),
  TypedReducer<ChallengeScreenState, SelectCurrentQuestionAction>(
    _selectCurrentQuestionActionReducer,
  ),
]);

ChallengeScreenState _initializeChallengeScreenReducer(
  ChallengeScreenState state,
  InitializeChallengeScreenAction action,
) {
  return state.copyWith(
    allQuestions: action.questions,
  );
}

ChallengeScreenState _nextChallengeScreenReducer(
  ChallengeScreenState state,
  NextChallengeScreenAction _,
) {
  int nextIndex = state.currentIndex + 1;
  if (nextIndex < state.allQuestions.length) {
    return state.copyWith(currentIndex: nextIndex);
  }

  return state;
}

ChallengeScreenState _previousChallengeScreenReducer(
  ChallengeScreenState state,
  PreviousChallengeScreenAction _,
) {
  int previousIndex = state.currentIndex - 1;
  if (previousIndex >= 0) {
    return state.copyWith(currentIndex: previousIndex);
  }

  return state;
}

ChallengeScreenState _toggleLoadingScreenReducer(
  ChallengeScreenState state,
  ToggleLoadingScreenAction _,
) {
  return state.copyWith(isLoading: !state.isLoading);
}

ChallengeScreenState _selectHomeScreenTabReducer(
  ChallengeScreenState state,
  SelectHomeScreenTabAction action,
) {
  return state.copyWith(selectedHomeScreenTab: action.tab);
}

ChallengeScreenState _likeActionReducer(
  ChallengeScreenState state,
  LikeAnswerAction _,
) {
  return state;
}

ChallengeScreenState _unlikeActionReducer(
  ChallengeScreenState state,
  UnlikeAnswerAction _,
) {
  return state;
}

ChallengeScreenState _selectCurrentQuestionActionReducer(
  ChallengeScreenState state,
  SelectCurrentQuestionAction action,
) {
  int index = state.indexFromQuestionId(action.questionId);

  return state.copyWith(currentIndex: index);
}
