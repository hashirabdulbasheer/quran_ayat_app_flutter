import '../../../../../notes/domain/entities/quran_note.dart';
import '../../../../../tags/domain/entities/quran_tag.dart';
import '../../../../../tags/domain/entities/quran_tag_aya.dart';
import '../../app_state.dart';

/// REDUCER
///

AppState appStateReducer(
  AppState state,
  dynamic action,
) {
  if (action is AppStateFetchTagsSucceededAction) {
    Map<String, List<String>> stateTags = {};
    for (QuranTag tag in action.fetchedTags) {
      for (QuranTagAya aya in tag.ayas) {
        String key = "${aya.suraIndex}_${aya.ayaIndex}";
        if (stateTags[key] == null) {
          stateTags[key] = [];
        }
        stateTags[key]?.add(tag.name);
      }
    }

    return state.copyWith(
      originalTags: action.fetchedTags,
      tags: stateTags,
    );
  } else if (action is AppStateResetAction) {
    // Reset Tag
    return const AppState();
  } else if (action is AppStateCreateTagFailureAction ||
      action is AppStateAddTagFailureAction ||
      action is AppStateRemoveTagFailureAction ||
      action is AppStateDeleteTagFailureAction) {
    return state.copyWith(
      lastActionStatus: AppStateActionStatus(
        action: action.runtimeType.toString(),
        message: (action as AppStateModifyTagResponseBaseAction).message,
      ),
    );
  } else if (action is AppStateCreateTagSucceededAction ||
      action is AppStateAddTagSucceededAction ||
      action is AppStateRemoveTagSucceededAction ||
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

  return state;
}
