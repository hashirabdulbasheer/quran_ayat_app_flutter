import 'package:redux/redux.dart';
import '../../../../../../models/qr_user_model.dart';
import '../../../../../../utils/logger_utils.dart';
import '../../../../../auth/domain/auth_factory.dart';
import '../../../../../core/domain/app_state/app_state.dart';
import '../../../entities/quran_tag.dart';
import '../../../entities/quran_tag_aya.dart';
import '../../../tags_manager.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createTagOperationsMiddleware() {
  return [
    TypedMiddleware<AppState, AddTagOperationAction>(_addTagMiddleware),
    TypedMiddleware<AppState, RemoveTagOperationAction>(_removeTagMiddleware),
  ];
}

void _addTagMiddleware(
  Store<AppState> store,
  dynamic action,
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
        suraIndex: (action as AddTagOperationAction).surahIndex,
        ayaIndex: action.ayaIndex,
      ));
      QuranTagsManager.instance
          .update(
        userId,
        masterTag,
      )
          .then((status) {
        if (status) {
          store.dispatch(AddTagOperationSucceededAction(
            message: "Saved tag - ${action.tag} 👍",
          ));
        } else {
          store.dispatch(
            AddTagOperationFailureAction(
              message: "Error saving tag - ${action.tag} 😔",
            ),
          );
        }
      });
    } catch (error) {
      QuranLogger.logE(error);
    }
    store.dispatch(AppStateLoadingAction(isLoading: false));
    store.dispatch(AppStateFetchTagsAction());
  }
  next(action);
}

void _removeTagMiddleware(
  Store<AppState> store,
  dynamic action,
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
          store.dispatch(RemoveTagOperationSucceededAction(
            message: "Removed tag - ${action.tag} 👍",
          ));
        } else {
          store.dispatch(
            RemoveTagOperationFailureAction(
              message: "Error removing tag - ${action.tag} 😔",
            ),
          );
        }
      });
    } catch (error) {
      QuranLogger.logE(error);
    }
    store.dispatch(AppStateLoadingAction(isLoading: false));
    store.dispatch(AppStateFetchTagsAction());
  }
  next(action);
}
