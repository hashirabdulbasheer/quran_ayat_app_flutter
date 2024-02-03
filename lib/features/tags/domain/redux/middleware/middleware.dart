import 'package:redux/redux.dart';

import '../../../../../../models/qr_user_model.dart';
import '../../../../../../utils/logger_utils.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../entities/quran_tag.dart';
import '../../entities/quran_tag_aya.dart';
import '../../tags_manager.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createTagOperationsMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeTagsAction>(_initializeTagsMiddleware),
    TypedMiddleware<AppState, FetchTagsAction>(_fetchTagsMiddleware),
    TypedMiddleware<AppState, CreateTagAction>(_createTagMiddleware),
    TypedMiddleware<AppState, DeleteTagAction>(_deleteTagMiddleware),
    TypedMiddleware<AppState, AddTagAction>(_addTagMiddleware),
    TypedMiddleware<AppState, RemoveTagAction>(_removeTagMiddleware),
  ];
}

void _initializeTagsMiddleware(
  Store<AppState> store,
  InitializeTagsAction action,
  NextDispatcher next,
) {
  // Initialize tags
  store.dispatch(FetchTagsAction());
  next(action);
}

void _fetchTagsMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  // Fetch tags
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    store.dispatch(AppStateLoadingAction(isLoading: true));
    QuranTagsManager.instance
        .fetchAll(
      user.uid,
    )
        .then((tags) {
      store.dispatch(FetchTagsSucceededAction(tags));
      store.dispatch(AppStateLoadingAction(isLoading: false));
    });
  }
  next(action);
}

void _createTagMiddleware(
  Store<AppState> store,
  CreateTagAction action,
  NextDispatcher next,
) {
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    String userId = user.uid;
    store.dispatch(AppStateLoadingAction(isLoading: true));
    QuranTagsManager.instance
        .create(
      userId,
      action.tag,
    )
        .then((response) {
      if (response.isSuccessful) {
        store.dispatch(CreateTagSucceededAction(
          message: "Saved tag - ${action.tag} 👍",
        ));
      } else {
        store.dispatch(CreateTagFailureAction(
          message: "Error creating tag - ${action.tag} 😔",
        ));
      }
      store.dispatch(AppStateLoadingAction(isLoading: false));
      store.dispatch(FetchTagsAction());
    });
  }
  next(action);
}

void _deleteTagMiddleware(
  Store<AppState> _,
  DeleteTagAction action,
  NextDispatcher next,
) {
  /// TODO: To be implemented
  next(action);
}

void _addTagMiddleware(
  Store<AppState> store,
  AddTagAction action,
  NextDispatcher next,
) {
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    String userId = user.uid;
    store.dispatch(AppStateLoadingAction(isLoading: true));
    try {
      QuranTag masterTag = store.state.tags.originalTags
          .firstWhere((element) => element.name == action.tag);
      masterTag.ayas.removeWhere((element) =>
          element.suraIndex == action.surahIndex &&
          element.ayaIndex == action.ayaIndex);
      masterTag.ayas.add(QuranTagAya(
        suraIndex: action.surahIndex,
        ayaIndex: action.ayaIndex,
      ));
      QuranTagsManager.instance
          .update(
        userId,
        masterTag,
      )
          .then((status) {
        if (status) {
          store.dispatch(AddTagSucceededAction(
            message: "Saved tag - ${action.tag} 👍",
          ));
        } else {
          store.dispatch(
            AddTagFailureAction(
              message: "Error saving tag - ${action.tag} 😔",
            ),
          );
        }
        store.dispatch(AppStateLoadingAction(isLoading: false));
        store.dispatch(FetchTagsAction());
      });
    } catch (error) {
      QuranLogger.logE(error);
    }
  }
  next(action);
}

void _removeTagMiddleware(
  Store<AppState> store,
  RemoveTagAction action,
  NextDispatcher next,
) {
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    store.dispatch(AppStateLoadingAction(isLoading: true));
    String userId = user.uid;
    try {
      QuranTag masterTag = store.state.tags.originalTags
          .firstWhere((element) => element.name == action.tag);
      masterTag.ayas.removeWhere((element) =>
          element.suraIndex == action.surahIndex &&
          element.ayaIndex == action.ayaIndex);

      QuranTagsManager.instance
          .update(
        userId,
        masterTag,
      )
          .then((status) {
        if (status) {
          store.dispatch(RemoveTagSucceededAction(
            message: "Removed tag - ${action.tag} 👍",
          ));
        } else {
          store.dispatch(
            RemoveTagFailureAction(
              message: "Error removing tag - ${action.tag} 😔",
            ),
          );
        }
        store.dispatch(AppStateLoadingAction(isLoading: false));
        store.dispatch(FetchTagsAction());
      });
    } catch (error) {
      QuranLogger.logE(error);
    }
  }
  next(action);
}
