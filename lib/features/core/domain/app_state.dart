import 'package:flutter/material.dart';

import '../../../models/qr_response_model.dart';
import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../../tags/domain/entities/quran_master_tag.dart';
import '../../tags/domain/entities/quran_master_tag_aya.dart';
import '../../tags/domain/tags_manager.dart';
import 'package:redux/redux.dart';

/// STATE
///
@immutable
class AppState {
  final List<QuranMasterTag> originalTags;
  final Map<String, List<String>> tags;
  final StateError? error;
  final bool isLoading;

  const AppState({
    this.tags = const {},
    this.originalTags = const [],
    this.error,
    this.isLoading = false,
  });

  AppState copyWith({
    List<QuranMasterTag>? originalTags,
    Map<String, List<String>>? tags,
    StateError? error,
    bool? isLoading,
  }) {
    return AppState(
      tags: tags ?? this.tags,
      originalTags: originalTags ?? this.originalTags,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<String>? getTags(int surahIndex, int ayaIndex,) {
    String key = "${surahIndex}_$ayaIndex";

    return tags[key];
  }
}

enum AppStateTagModifyAction { create, addAya, removeAya, delete }

/// ACTIONS
///

class AppStateAction {}

class AppStateInitializeAction extends AppStateAction {}

class AppStateResetAction extends AppStateAction {}

/// TAG ACTIONS
///
class AppStateFetchTagsAction extends AppStateAction {}

class AppStateLoadingAction extends AppStateAction {
  final bool isLoading;

  AppStateLoadingAction({
    required this.isLoading,
  });
}

class AppStateModifyTagAction extends AppStateAction {
  final int surahIndex;
  final int ayaIndex;
  final String tag;
  final AppStateTagModifyAction action;

  AppStateModifyTagAction({
    required this.surahIndex,
    required this.ayaIndex,
    required this.tag,
    required this.action,
  });
}

class AppStateFetchTagsSucceededAction extends AppStateAction {
  final List<QuranMasterTag> fetchedTags;

  AppStateFetchTagsSucceededAction(
    this.fetchedTags,
  );
}

class AppStateModifyTagSucceededAction extends AppStateAction {}

class AppStateModifyTagFailureAction extends AppStateAction {
  final String message;

  AppStateModifyTagFailureAction({
    required this.message,
  });
}

/// REDUCER
///

AppState appStateReducer(
  AppState state,
  dynamic action,
) {
  if (action is AppStateFetchTagsSucceededAction) {
    Map<String, List<String>> stateTags = {};
    for (QuranMasterTag tag in action.fetchedTags) {
      for (QuranMasterTagAya aya in tag.ayas) {
        String key = "${aya.suraIndex}_${aya.ayaIndex}";
        if (stateTags[key] == null) {
          stateTags[key] = [];
        }
        stateTags[key]?.add(tag.name);
      }
    }
    
    return AppState(
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
  }

  return state;
}

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
  } else if (action is AppStateFetchTagsAction) {
    // Fetch tags
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      List<QuranMasterTag> tags = await QuranTagsManager.instance.fetchAll(
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
            QuranMasterTag masterTag = store.state.originalTags
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
            QuranMasterTag masterTag = store.state.originalTags
                .firstWhere((element) => element.name == action.tag);
            masterTag.ayas.removeWhere((element) =>
                element.suraIndex == action.surahIndex &&
                element.ayaIndex == action.ayaIndex);
            masterTag.ayas.add(QuranMasterTagAya(
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
  }
  next(action);
}

class LoggerMiddleware<State> implements MiddlewareClass<State> {
  @override
  void call(
    Store<State> store,
    dynamic action,
    NextDispatcher next,
  ) {
    next(action);

    print("Middleware: { ${action.runtimeType} }");
  }
}
