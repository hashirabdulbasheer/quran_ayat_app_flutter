import '../../../../../notes/domain/entities/quran_note.dart';
import '../../../../../tags/domain/redux/tags_operations/reducers/reducer.dart';
import '../../app_state.dart';

/// REDUCER
///

AppState appStateReducer(
  AppState state,
  dynamic action,
) {
  print("appStateReducer -> $action");
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
  } else if (action is AppStateFetchNotesSucceededAction) {
    Map<String, List<QuranNote>> stateNotes = {};
    for (QuranNote note in action.fetchedNotes) {
      String key = "${note.suraIndex}_${note.ayaIndex}";
      if (stateNotes[key] == null) {
        stateNotes[key] = [];
      }
      stateNotes[key]?.add(note);
    }

    return state.copyWith(
      originalNotes: action.fetchedNotes,
      notes: stateNotes,
    );
  } else if (action is AppStateResetStatusAction) {
    return state.copyWith(
      lastActionStatus: const AppStateActionStatus(
        action: "",
        message: "",
      ),
    );
  } else if (action is AppStateCreateNoteSucceededAction ||
      action is AppStateUpdateNoteSucceededAction ||
      action is AppStateDeleteNoteSucceededAction) {
    return state.copyWith(
      lastActionStatus: AppStateActionStatus(
        action: action.runtimeType.toString(),
        message: (action as AppStateNoteOperationsResponseBaseAction).message,
      ),
    );
  } else if (action is AppStateNotesFailureAction) {
    return state.copyWith(
      lastActionStatus: AppStateActionStatus(
        action: action.runtimeType.toString(),
        message: action.message,
      ),
    );
  }

  return state.copyWith(
    tags: tagOperationsReducer(
      state.tags,
      action,
    ),
  );
}
