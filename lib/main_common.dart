import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/challenge/domain/redux/middleware/middleware.dart';
import 'features/core/domain/app_state/app_state.dart';
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
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
      ),
    );
  }

  void onSettingsChangedListener(String _) {
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
