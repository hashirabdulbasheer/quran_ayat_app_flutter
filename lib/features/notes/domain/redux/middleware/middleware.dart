import 'package:redux/redux.dart';
import '../../../../../../models/qr_user_model.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../notes_manager.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createNotesMiddleware() {
  return [
    TypedMiddleware<AppState, CreateNoteAction>(_createNoteMiddleware),
    TypedMiddleware<AppState, UpdateNoteAction>(_updateNoteMiddleware),
    TypedMiddleware<AppState, DeleteNoteAction>(_deleteNoteMiddleware),
  ];
}

void _createNoteMiddleware(
  Store<AppState> store,
  CreateNoteAction action,
  NextDispatcher next,
) {
  // Fetch notes
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
    store.dispatch(AppStateFetchNotesAction());
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
    store.dispatch(AppStateFetchNotesAction());
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
    store.dispatch(AppStateFetchNotesAction());
  }
  next(action);
}
