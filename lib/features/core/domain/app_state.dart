import 'package:flutter/material.dart';

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
  final Map<String, List<String>> tags;

  const AppState({
    this.tags = const {},
  });
}

/// ACTIONS
///

class AppStateAction {}

class AppStateInitializeAction extends AppStateAction {}

class AppStateFetchTagsAction extends AppStateAction {}

class AppStateFetchTagsSucceededAction extends AppStateAction {
  final List<QuranMasterTag> fetchedTags;

  AppStateFetchTagsSucceededAction(
    this.fetchedTags,
  );
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
      tags: stateTags,
    );
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
    store.dispatch(AppStateFetchTagsAction());
  } else if (action is AppStateFetchTagsAction) {
    QuranUser? user = QuranAuthFactory.engine?.getUser();
    if (user != null) {
      List<QuranMasterTag> tags = await QuranTagsManager.instance.fetchAll(
        user.uid,
      );
      store.dispatch(AppStateFetchTagsSucceededAction(tags));
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
