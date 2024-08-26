import 'package:redux/redux.dart';

import '../../../../../auth/domain/auth_factory.dart';
import '../../../../../challenge/domain/redux/reducers/reducers.dart';
import '../../../../../newAyat/domain/redux/reducers/reducers.dart';
import '../../../../../notes/domain/redux/reducers/reducer.dart';
import '../../../../../tags/domain/redux/reducers/reducer.dart';
import '../../app_state.dart';

/// REDUCER
///
Reducer<AppState> appStateReducer = combineReducers<AppState>([
  TypedReducer<AppState, AppStateInitializeAction>(
    _initializeAppStateReducer,
  ).call,
  TypedReducer<AppState, AppStateResetAction>(
    _resetAppStateReducer,
  ).call,
  TypedReducer<AppState, AppStateLoadingAction>(
    _loadingAppStateReducer,
  ).call,
  TypedReducer<AppState, AppStateResetStatusAction>(
    _resetAppStateStatusReducer,
  ).call,
  TypedReducer<AppState, AppStateSelectAppModeAction>(
    _selectAppModeReducer,
  ).call,
  TypedReducer<AppState, AppStateUserRoleAction>(
    _setAppStateUserRoleReducer,
  ).call,
  TypedReducer<AppState, dynamic>(
    _allOtherReducer,
  ).call,
]);

// redirect everything else to child states
AppState _allOtherReducer(
  AppState state,
  dynamic action,
) {
  return state.copyWith(
    tags: tagReducer(
      state.tags,
      action,
    ),
    notes: notesReducer(
      state.notes,
      action,
    ),
    reader: readerScreenReducer(
      state.reader,
      action,
    ),
    challenge: challengeScreenReducer(
      state.challenge,
      action,
    ),
  );
}

AppState _initializeAppStateReducer(
  AppState state,
  AppStateInitializeAction action,
) {
  return state.copyWith(
    tags: tagReducer(
      state.tags,
      action,
    ),
    notes: notesReducer(
      state.notes,
      action,
    ),
    user: QuranAuthFactory.engine.getUser(),
  );
}

AppState _resetAppStateReducer(
  AppState state,
  AppStateResetAction action,
) {
  return const AppState();
}

AppState _loadingAppStateReducer(
  AppState state,
  AppStateLoadingAction action,
) {
  return state.copyWith(isLoading: action.isLoading);
}

AppState _resetAppStateStatusReducer(
  AppState state,
  AppStateResetStatusAction action,
) {
  return state.copyWith(
    lastActionStatus: const AppStateActionStatus(
      action: "",
      message: "",
    ),
  );
}

AppState _selectAppModeReducer(
  AppState state,
  AppStateSelectAppModeAction action,
) {
  return state.copyWith(
    appMode: action.appMode,
  );
}

AppState _setAppStateUserRoleReducer(
  AppState state,
  AppStateUserRoleAction action,
) {
  return state.copyWith(
    isAdminUser: action.isAdmin,
  );
}
