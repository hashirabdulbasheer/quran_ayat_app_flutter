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
]);

ChallengeScreenState _initializeChallengeScreenReducer(
  ChallengeScreenState state,
  InitializeChallengeScreenAction action,
) {

  return state.copyWith(questions: action.questions);
}

ChallengeScreenState _nextChallengeScreenReducer(
  ChallengeScreenState state,
  NextChallengeScreenAction action,
) {
  int nextIndex = state.currentIndex + 1;
  if (nextIndex < state.questions.length) {
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
