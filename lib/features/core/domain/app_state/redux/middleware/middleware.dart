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
      } catch (_) {}
      QuranLogger.logAnalytics("url-sura-aya");
    } else if (suraIndex != null && suraIndex.isNotEmpty) {
      // has only one
      // the last path will be surah index
      try {
        var selectedSurahIndex = int.parse(suraIndex);
        store.dispatch(SelectParticularAyaAction(
          index: SurahIndex.fromHuman(
            sura: selectedSurahIndex,
            aya: 1,
          ),
        ));

        return true;
      } catch (_) {}
      QuranLogger.logAnalytics("url-aya");
    }
  }

  return false;
}
