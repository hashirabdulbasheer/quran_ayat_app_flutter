import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/bookmark/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/bookmark/domain/redux/middleware/middleware.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/settings/domain/settings_manager.dart';
import 'package:redux/redux.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/core/domain/app_state/app_state.dart';
import 'features/newAyat/domain/redux/middleware/middleware.dart';
import 'features/notes/domain/redux/middleware/middleware.dart';
import 'features/settings/domain/theme_manager.dart';
import 'features/tags/domain/redux/middleware/middleware.dart';
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
    if (kIsWeb) {
      ServicesBinding.instance.keyboard.addHandler(_onKey);
    }
  }

  @override
  void dispose() {
    QuranAuthFactory.engine.unregisterAuthChangeListener(_authChangeListener);
    QuranSettingsManager.instance.removeListeners();
    if (kIsWeb) {
      ServicesBinding.instance.keyboard.removeHandler(_onKey);
    }
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

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;
    // if (event is KeyDownEvent) {
    //   if (key == "Arrow Right") {
    //     store.dispatch(PreviousAyaAction());
    //   } else {
    //     store.dispatch(NextAyaAction());
    //   }
    // }

    return false;
  }

  void onSettingsChangedListener(String settings) {
    // settings changed
    // fire actions to update screen
    store.dispatch(ShowLoadingAction());
    store.dispatch(HideLoadingAction());
  }

  void _authChangeListener() async {
    store.dispatch(InitBookmarkAction());
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
          store.dispatch(SelectParticularAyaAction(
            surah: selectedSurahIndex,
            aya: ayaIndexInt,
          ));
        } catch (_) {}
        QuranLogger.logAnalytics("url-sura-aya");
      } else if (suraIndex != null && suraIndex.isNotEmpty) {
        // has only one
        // the last path will be surah index
        try {
          var selectedSurahIndex = int.parse(suraIndex);
          store.dispatch(SelectParticularAyaAction(
            surah: selectedSurahIndex,
            aya: 1,
          ));
        } catch (_) {}
        QuranLogger.logAnalytics("url-aya");
      }
    }
  }
}
