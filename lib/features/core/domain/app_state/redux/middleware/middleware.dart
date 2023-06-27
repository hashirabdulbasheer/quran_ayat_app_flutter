import 'package:redux/redux.dart';

import '../../../../../../models/qr_response_model.dart';
import '../../../../../../models/qr_user_model.dart';
import '../../../../../auth/domain/auth_factory.dart';
import '../../../../../notes/domain/entities/quran_note.dart';
import '../../../../../notes/domain/notes_manager.dart';
import '../../../../../tags/domain/entities/quran_tag.dart';
import '../../../../../tags/domain/entities/quran_tag_aya.dart';
import '../../../../../tags/domain/tags_manager.dart';
import '../../app_state.dart';

/// MIDDLEWARE
///

void appStateMiddleware(
    Store<AppState> store,
    dynamic action,
    NextDispatcher next,
    ) async {
  if (action is AppStateInitializeAction) {
    // Initialization actions
    store.dispatch(AppStateFetchTagsAction());
    store.dispatch(AppStateFetchNotesAction());
  } else if (action is AppStateFetchTagsAction) {
    // Fetch tags
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      List<QuranTag> tags = await QuranTagsManager.instance.fetchAll(
        user.uid,
      );
      store.dispatch(AppStateFetchTagsSucceededAction(tags));
    }
  } else if (action is AppStateModifyTagAction) {
    // Modify tags
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      String userId = user.uid;
      switch (action.action) {
        case AppStateTagModifyAction.create:
          QuranResponse response = await QuranTagsManager.instance.create(
            userId,
            action.tag,
          );
          if (response.isSuccessful) {
            store.dispatch(AppStateModifyTagSucceededAction());
          } else {
            store.dispatch(AppStateModifyTagFailureAction(
              message: "Error creating tag - ${action.tag}",
            ));
          }
          break;

        case AppStateTagModifyAction.removeAya:
          try {
            QuranTag masterTag = store.state.originalTags
                .firstWhere((element) => element.name == action.tag);
            masterTag.ayas.removeWhere((element) =>
            element.suraIndex == action.surahIndex &&
                element.ayaIndex == action.ayaIndex);
            if (await QuranTagsManager.instance.update(
              userId,
              masterTag,
            )) {
              store.dispatch(AppStateModifyTagSucceededAction());
            } else {
              store.dispatch(
                AppStateModifyTagFailureAction(message: "Error updating"),
              );
            }
          } catch (error) {
            print(error);
          }
          break;

        case AppStateTagModifyAction.addAya:
          try {
            QuranTag masterTag = store.state.originalTags
                .firstWhere((element) => element.name == action.tag);
            masterTag.ayas.removeWhere((element) =>
            element.suraIndex == action.surahIndex &&
                element.ayaIndex == action.ayaIndex);
            masterTag.ayas.add(QuranTagAya(
              suraIndex: action.surahIndex,
              ayaIndex: action.ayaIndex,
            ));
            if (await QuranTagsManager.instance.update(
              userId,
              masterTag,
            )) {
              store.dispatch(AppStateModifyTagSucceededAction());
            } else {
              store.dispatch(
                AppStateModifyTagFailureAction(message: "Error updating"),
              );
            }
          } catch (error) {
            print(error);
          }
          break;

        case AppStateTagModifyAction.delete:
        // TODO: Not implemented
          break;
      }

      store.dispatch(AppStateFetchTagsAction());
    }
  } else if (action is AppStateFetchNotesAction) {
    // Fetch tags
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      List<QuranNote> notes = await QuranNotesManager.instance.fetchAll(
        user.uid,
      );
      store.dispatch(AppStateFetchNotesSucceededAction(notes));
    }
  } else if (action is AppStateCreateNoteAction) {
    // Fetch tags
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      QuranResponse response = await QuranNotesManager.instance.create(
        user.uid,
        action.note,
      );
      if (response.isSuccessful) {
        store.dispatch(AppStateCreateNoteSucceededAction());
      } else {
        store.dispatch(
          AppStateNotesFailureAction(message: "Error creating note"),
        );
      }
    }
    store.dispatch(AppStateFetchNotesAction());
  } else if (action is AppStateDeleteNoteAction) {
    // Fetch tags
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      bool status = await QuranNotesManager.instance.delete(
        user.uid,
        action.note,
      );
      if (status) {
        store.dispatch(AppStateDeleteNoteSucceededAction());
      } else {
        store.dispatch(
          AppStateNotesFailureAction(message: "Error deleting note"),
        );
      }
    }
    store.dispatch(AppStateFetchNotesAction());
  } else if (action is AppStateUpdateNoteAction) {
    // Fetch tags
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      bool status = await QuranNotesManager.instance.update(
        user.uid,
        action.note,
      );
      if (status) {
        store.dispatch(AppStateUpdateNoteSucceededAction());
      } else {
        store.dispatch(
          AppStateNotesFailureAction(message: "Error updating note"),
        );
      }
    }
    store.dispatch(AppStateFetchNotesAction());
  }
  next(action);
}
