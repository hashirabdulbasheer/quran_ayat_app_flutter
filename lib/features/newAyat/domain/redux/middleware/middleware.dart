import 'package:noble_quran/noble_quran.dart';
import 'package:redux/redux.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../settings/domain/settings_manager.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createReaderScreenMiddleware() {
  return [
    TypedMiddleware<AppState, InitializeReaderScreenAction>(
      _initializeMiddleware,
    ),
    TypedMiddleware<AppState, IncreaseFontSizeAction>(
      _increaseFontSizeMiddleware,
    ),
    TypedMiddleware<AppState, DecreaseFontSizeAction>(
      _decreaseFontSizeMiddleware,
    ),
    TypedMiddleware<AppState, ResetFontSizeAction>(
      _resetFontSizeMiddleware,
    ),
  ];
}

void _initializeMiddleware(
  Store<AppState> store,
  InitializeReaderScreenAction action,
  NextDispatcher next,
) {
  // Initialize surah titles
  NobleQuran.getSurahList().then((surahList) {
    store.dispatch(SetSurahListAction(
      surahs: surahList,
    ));
  });
  next(action);
}

void _increaseFontSizeMiddleware(
  Store<AppState> store,
  IncreaseFontSizeAction action,
  NextDispatcher next,
) {
  store.dispatch(ShowLoadingAction());
  QuranSettingsManager.instance.incrementFontSize();
  store.dispatch(HideLoadingAction());
  next(action);
}

void _decreaseFontSizeMiddleware(
    Store<AppState> store,
    DecreaseFontSizeAction action,
    NextDispatcher next,
    ) {
  store.dispatch(ShowLoadingAction());
  QuranSettingsManager.instance.decrementFontSize();
  store.dispatch(HideLoadingAction());
  next(action);
}

void _resetFontSizeMiddleware(
    Store<AppState> store,
    ResetFontSizeAction action,
    NextDispatcher next,
    ) {
  store.dispatch(ShowLoadingAction());
  QuranSettingsManager.instance.resetFontSize();
  store.dispatch(HideLoadingAction());
  next(action);
}
