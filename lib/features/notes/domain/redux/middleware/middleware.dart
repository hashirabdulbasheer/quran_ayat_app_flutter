import 'package:redux/redux.dart';
import '../../../../../../models/qr_user_model.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../entities/quran_note.dart';
import '../../notes_manager.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createNotesMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeNotesAction>(_initializeNotesMiddleware),
    TypedMiddleware<AppState, FetchNotesAction>(_fetchNotesMiddleware),
    TypedMiddleware<AppState, CreateNoteAction>(_createNoteMiddleware),
    TypedMiddleware<AppState, UpdateNoteAction>(_updateNoteMiddleware),
    TypedMiddleware<AppState, DeleteNoteAction>(_deleteNoteMiddleware),
  ];
}

void _initializeNotesMiddleware(
    Store<AppState> store,
    InitializeNotesAction action,
    NextDispatcher next,
    ) {
  // Initialize notes
  store.dispatch(FetchNotesAction());
  next(action);
}

void _fetchNotesMiddleware(
  Store<AppState> store,
  FetchNotesAction action,
  NextDispatcher next,
) {
  // Fetch notes
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    store.dispatch(NotesLoadingAction(isLoading: true));
    QuranNotesManager.instance
        .fetchAll(
      user.uid,
    )
        .then((notes) {
      List<QuranNote> fetchedNotes = notes;
      // sort descending by time to show latest on top
      fetchedNotes.sort((
          a,
          b,
          ) =>
      b.createdOn - a.createdOn);
      store.dispatch(NotesLoadingAction(isLoading: false));
      store.dispatch(FetchNotesSucceededAction(fetchedNotes));
    });
  }
  next(action);
}

void _createNoteMiddleware(
  Store<AppState> store,
  CreateNoteAction action,
  NextDispatcher next,
) {
  // Create notes
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    store.dispatch(NotesLoadingAction(isLoading: true));
    QuranNotesManager.instance
        .create(
      user.uid,
      action.note,
    )
        .then((response) {
      if (response.isSuccessful) {
        store.dispatch(CreateNoteSucceededAction(message: "Saved 👍"));
      } else {
        store.dispatch(
          NotesFailureAction(message: "Error creating note 😔"),
        );
      }
    });
    store.dispatch(NotesLoadingAction(isLoading: false));
    store.dispatch(FetchNotesAction());
  }
  next(action);
}

void _updateNoteMiddleware(
  Store<AppState> store,
  UpdateNoteAction action,
  NextDispatcher next,
) {
  // Update notes
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    store.dispatch(NotesLoadingAction(isLoading: true));
    QuranNotesManager.instance
        .update(
      user.uid,
      action.note,
    )
        .then((response) {
      if (response) {
        store.dispatch(UpdateNoteSucceededAction(message: "Updated 👍"));
      } else {
        store.dispatch(
          NotesFailureAction(message: "Error updating note 😔"),
        );
      }
    });
    store.dispatch(NotesLoadingAction(isLoading: false));
    store.dispatch(FetchNotesAction());
  }
  next(action);
}

void _deleteNoteMiddleware(
  Store<AppState> store,
  DeleteNoteAction action,
  NextDispatcher next,
) {
  // Delete notes
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    store.dispatch(NotesLoadingAction(isLoading: true));
    QuranNotesManager.instance
        .delete(
      user.uid,
      action.note,
    )
        .then((response) {
      if (response) {
        store.dispatch(
          DeleteNoteSucceededAction(message: "Deleted 👍"),
        );
      } else {
        store.dispatch(
          NotesFailureAction(message: "Error deleting note 😔"),
        );
      }
    });
    store.dispatch(NotesLoadingAction(isLoading: false));
    store.dispatch(FetchNotesAction());
  }
  next(action);
}
