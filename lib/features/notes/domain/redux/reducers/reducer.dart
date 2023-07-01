import 'package:redux/redux.dart';
import '../../../../core/domain/app_state/redux/actions/actions.dart';
import '../../entities/quran_note.dart';
import '../actions/actions.dart';
import '../notes_state.dart';

/// REDUCER
///

Reducer<NotesState> notesReducer = combineReducers<NotesState>([
  TypedReducer<NotesState, AppStateFetchNotesSucceededAction>(
    _fetchNotesReducer,
  ),
  TypedReducer<NotesState, ResetNotesStatusAction>(
    _resetNotesStatusReducer,
  ),
  TypedReducer<NotesState, CreateNoteSucceededAction>(
    _createSucceededActionNotesReducer,
  ),
  TypedReducer<NotesState, UpdateNoteSucceededAction>(
    _updateSucceededActionNotesReducer,
  ),
  TypedReducer<NotesState, DeleteNoteSucceededAction>(
    _deleteSucceededActionNotesReducer,
  ),
  TypedReducer<NotesState, NotesFailureAction>(
    _failureActionNotesReducer,
  ),
  TypedReducer<NotesState, NotesLoadingAction>(
    _loadingNotesStatusReducer,
  ),
]);

NotesState _fetchNotesReducer(
  NotesState state,
  AppStateFetchNotesSucceededAction action,
) {
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

NotesState _resetNotesStatusReducer(
  NotesState state,
  ResetNotesStatusAction action,
) {
  return state.copyWith(
    lastActionStatus: const AppStateActionStatus(
      action: "",
      message: "",
    ),
  );
}

NotesState _loadingNotesStatusReducer(
  NotesState state,
  NotesLoadingAction action,
) {
  return state.copyWith(
    isLoading: action.isLoading,
  );
}

NotesState _createSucceededActionNotesReducer(
  NotesState state,
  CreateNoteSucceededAction action,
) {
  return state.copyWith(
    lastActionStatus: AppStateActionStatus(
      action: action.runtimeType.toString(),
      message: action.message,
    ),
  );
}

NotesState _updateSucceededActionNotesReducer(
  NotesState state,
  UpdateNoteSucceededAction action,
) {
  return state.copyWith(
    lastActionStatus: AppStateActionStatus(
      action: action.runtimeType.toString(),
      message: action.message,
    ),
  );
}

NotesState _deleteSucceededActionNotesReducer(
  NotesState state,
  DeleteNoteSucceededAction action,
) {
  return state.copyWith(
    lastActionStatus: AppStateActionStatus(
      action: action.runtimeType.toString(),
      message: action.message,
    ),
  );
}

NotesState _failureActionNotesReducer(
  NotesState state,
  NotesFailureAction action,
) {
  return state.copyWith(
    lastActionStatus: AppStateActionStatus(
      action: action.runtimeType.toString(),
      message: action.message,
    ),
  );
}
