import '../../../../../notes/domain/entities/quran_note.dart';
import '../../../../../notes/domain/redux/reducers/reducer.dart';
import '../../../../../tags/domain/redux/tags_operations/reducers/reducer.dart';
import '../../app_state.dart';

/// REDUCER
///

AppState appStateReducer(
  AppState state,
  dynamic action,
) {
  if (action is AppStateResetAction) {
    // Reset Tag
    return const AppState();
  } else if (action is AppStateCreateTagFailureAction ||
      action is AppStateDeleteTagFailureAction) {
    return state.copyWith(
      lastActionStatus: AppStateActionStatus(
        action: action.runtimeType.toString(),
        message: (action as AppStateModifyTagResponseBaseAction).message,
      ),
    );
  } else if (action is AppStateCreateTagSucceededAction ||
      action is AppStateDeleteTagSucceededAction) {
    return state.copyWith(
      lastActionStatus: AppStateActionStatus(
        action: action.runtimeType.toString(),
        message: (action as AppStateModifyTagResponseBaseAction).message,
      ),
    );
  } else if (action is AppStateLoadingAction) {
    return state.copyWith(isLoading: action.isLoading);
  } else if (action is AppStateResetStatusAction) {
    return state.copyWith(
      lastActionStatus: const AppStateActionStatus(
        action: "",
        message: "",
      ),
    );
  }

  return state.copyWith(
    tags: tagOperationsReducer(
      state.tags,
      action,
    ),
    notes: notesReducer(
      state.notes,
      action,
    ),
  );
}
