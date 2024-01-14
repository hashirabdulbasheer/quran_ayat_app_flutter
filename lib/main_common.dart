import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/challenge/domain/redux/middleware/middleware.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/newAyat/data/surah_index.dart';
import 'features/newAyat/domain/redux/actions/actions.dart';
import 'features/newAyat/domain/redux/actions/bookmark_actions.dart';
import 'features/newAyat/domain/redux/middleware/bookmark_middleware.dart';
import 'features/newAyat/domain/redux/middleware/middleware.dart';
import 'features/notes/domain/redux/middleware/middleware.dart';
import 'features/settings/domain/settings_manager.dart';
import 'features/settings/domain/theme_manager.dart';
import 'features/tags/domain/redux/middleware/middleware.dart';
import 'models/qr_user_model.dart';
import 'utils/logger_utils.dart';

///
/// MAIN COMMON
///

class MyApp extends StatefulWidget {
  final Widget homeScreen;

  const MyApp({
    Key? key,
    required this.homeScreen,
  }) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final store = Store(
    appStateReducer,
    distinct: true,
    initialState: const AppState(),
    middleware: [
      appStateMiddleware,
      LoggerMiddleware<AppState>(),
      ...createTagOperationsMiddleware(),
      ...createNotesMiddleware(),
      ...createReaderScreenMiddleware(),
      ...createChallengeScreenMiddleware(),
      ...createBookmarkMiddleware(),
    ],
  );

  @override
  void initState() {
    super.initState();
    QuranAuthFactory.engine.registerAuthChangeListener(_authChangeListener);
    QuranSettingsManager.instance.registerListener(onSettingsChangedListener);
    _handleUrlPathsForWeb(
      context,
      store,
    );
  }

  @override
  void dispose() {
    QuranAuthFactory.engine.unregisterAuthChangeListener(_authChangeListener);
    QuranSettingsManager.instance.removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Quran',
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        theme: QuranThemeManager.instance.theme,
        darkTheme: QuranThemeManager.instance.darkTheme,
        themeMode: QuranThemeManager.instance.currentAppThemeMode,
        home: widget.homeScreen,
      ),
    );
  }

  void onSettingsChangedListener(String settings) {
    // settings changed
    // fire actions to update screen
    store.dispatch(InitializeReaderScreenAction());
    store.dispatch(ShowLoadingAction());
    store.dispatch(HideLoadingAction());
  }

  void _authChangeListener() async {
    store.dispatch(InitBookmarkAction());
    // update user rold
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      bool isAdmin = await QuranAuthFactory.engine.isAdmin(user.uid);
      store.dispatch(AppStateUserRoleAction(isAdmin: isAdmin));
    }
  }
}

void _handleUrlPathsForWeb(
  BuildContext context,
  Store<AppState> store,
) {
  /// url parameters
  final String? urlQuerySearchString = Uri.base.queryParameters["search"];
  final String? urlQuerySuraIndex = Uri.base.queryParameters["sura"];
  final String? urlQueryAyaIndex = Uri.base.queryParameters["aya"];
  if (kIsWeb) {
    String? searchString = urlQuerySearchString;
    String? suraIndex = urlQuerySuraIndex;
    String? ayaIndex = urlQueryAyaIndex;
    if (searchString != null && searchString.isNotEmpty) {
      // we have a search url
      // navigate to search screen
      // TODO: Implementation search via url params
      // Future.delayed(
      //   const Duration(seconds: 1),
      //   () => {
      //     Navigator.push<void>(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) =>
      //             QuranSearchScreen(searchString: searchString),
      //       ),
      //     ),
      //   },
      // );
      // QuranLogger.logAnalytics("url-search");
    } else {
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
          // TODO: Improve url parsing by implementing proper navigation and routing - this is a workaround
          Future<void>.delayed(
            const Duration(seconds: 1),
            () => store.dispatch(SelectParticularAyaAction(
              index: SurahIndex.fromHuman(
                sura: selectedSurahIndex,
                aya: ayaIndexInt,
              ),
            )),
          );
        } catch (_) {}
        QuranLogger.logAnalytics("url-sura-aya");
      } else if (suraIndex != null && suraIndex.isNotEmpty) {
        // has only one
        // the last path will be surah index
        try {
          var selectedSurahIndex = int.parse(suraIndex);
          // TODO: Improve url parsing by implementing proper navigation and routing - this is a workaround
          Future<void>.delayed(
            const Duration(seconds: 1),
            () => store.dispatch(SelectParticularAyaAction(
              index: SurahIndex.fromHuman(
                sura: selectedSurahIndex,
                aya: 1,
              ),
            )),
          );
        } catch (_) {}
        QuranLogger.logAnalytics("url-aya");
      }
    }
  }
}
