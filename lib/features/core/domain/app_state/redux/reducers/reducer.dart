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
    return const AppState(tags: {});
  } else if (action is AppStateModifyTagFailureAction) {
    return state.copyWith(error: StateError(action.message));
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
  }

  return state;
}
