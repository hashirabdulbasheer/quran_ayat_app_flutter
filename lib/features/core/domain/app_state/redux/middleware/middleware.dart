import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import '../../../../../../models/qr_user_model.dart';
import '../../../../../../utils/logger_utils.dart';
import '../../../../../auth/domain/auth_factory.dart';
import '../../../../../challenge/domain/redux/actions/actions.dart';
import '../../../../../newAyat/data/surah_index.dart';
import '../../../../../newAyat/domain/redux/actions/actions.dart';
import '../../../../../notes/domain/redux/actions/actions.dart';
import '../../../../../tags/domain/redux/actions/actions.dart';
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
    store.dispatch(InitializeTagsAction());
    store.dispatch(InitializeNotesAction());
    store.dispatch(InitializeChallengeScreenAction(questions: const []));
    if (!_handleUrlPathsForWeb(store)) {
      // only handle initialization if there is no param, otherwise it gets
      // initialized while handling params
      store.dispatch(InitializeReaderScreenAction());
    }

    // setting user role
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      bool isAdmin = await QuranAuthFactory.engine.isAdmin(user.uid);
      store.dispatch(AppStateUserRoleAction(isAdmin: isAdmin));
    }
  }
  next(action);
}

/// Handle URL params
/// old:
///   ?sura=18
///   ?sura=18&aya=100
/// new:
///   /18
///   /18/100
bool _handleUrlPathsForWeb(Store<AppState> store) {
  /// url parameters
  final String? urlQuerySuraIndex = Uri.base.queryParameters["sura"];
  final String? urlQueryAyaIndex = Uri.base.queryParameters["aya"];
  if (kIsWeb) {
    String? suraIndex = urlQuerySuraIndex;
    String? ayaIndex = urlQueryAyaIndex;
    // not a search url
    // check for surah/ayat format
    if (suraIndex != null &&
        ayaIndex != null &&
        suraIndex.isNotEmpty &&
        ayaIndex.isNotEmpty) {
      // have more than one
      // the last two paths should be surah/ayat format
      QuranLogger.logAnalytics("url-sura-aya");

      return _handleParams(
        store,
        suraIndex,
        ayaIndex,
      );
    } else if (suraIndex != null && suraIndex.isNotEmpty) {
      // has only one
      // the last path will be surah index
      QuranLogger.logAnalytics("url-sura-aya");

      return _handleParams(
        store,
        suraIndex,
        "1",
      );
    } else {
      // check for new format
      List<String> paths = Uri.base.path.trim().split("/");
      if (paths.length == 2) {
        QuranLogger.logAnalytics("url-aya");

        return _handleParams(
          store,
          paths[1],
          "1",
        );
      } else if (paths.length == 3) {
        QuranLogger.logAnalytics("url-aya");

        return _handleParams(
          store,
          paths[1],
          paths[2],
        );
      }
    }
  }

  return false;
}

bool _handleParams(
  Store<AppState> store,
  String suraIndex,
  String ayaIndex,
) {
  try {
    var selectedSurahIndex = int.parse(suraIndex);
    var ayaIndexInt = int.parse(ayaIndex);
    store.dispatch(SelectParticularAyaAction(
      index: SurahIndex.fromHuman(
        sura: selectedSurahIndex,
        aya: ayaIndexInt,
      ),
    ));

    return true;
  } catch (e) {
    QuranLogger.logE(e);
  }

  return false;
}
