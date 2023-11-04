import 'dart:math';

import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../utils/logger_utils.dart';
import '../../../../../utils/utils.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../notes/domain/redux/actions/actions.dart';
import '../../../../settings/domain/settings_manager.dart';
import '../../../../tags/domain/redux/actions/actions.dart';
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
    TypedMiddleware<AppState, NextAyaAction>(
      _nextAyaMiddleware,
    ),
    TypedMiddleware<AppState, PreviousAyaAction>(
      _previousAyaMiddleware,
    ),
    TypedMiddleware<AppState, ShareAyaAction>(
      _shareAyaReaderMiddleware,
    ),
    TypedMiddleware<AppState, RandomAyaAction>(
      _randomAyaReaderMiddleware,
    ),
    TypedMiddleware<AppState, SelectParticularAyaAction>(
      _selectParticularAyaReaderMiddleware,
    ),
    TypedMiddleware<AppState, SelectSurahAction>(
      _selectSurahReaderMiddleware,
    ),
    TypedMiddleware<AppState, dynamic>(
      _allOtherReaderMiddleware,
    ),
  ];
}

void _allOtherReaderMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action);
}

void _initializeMiddleware(
  Store<AppState> store,
  InitializeReaderScreenAction action,
  NextDispatcher next,
) async {
  // Initialize surah titles
  var surahList = await NobleQuran.getSurahList();
  store.dispatch(SetSurahListAction(
    surahs: surahList,
  ));
  // Initialize surah words
  List<List<NQWord>>? suraWords = await NobleQuran.getSurahWordByWord(
    0,
  );
  store.dispatch(SelectSurahAction(
    surah: 1,
    words: suraWords,
  ));
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

void _nextAyaMiddleware(
  Store<AppState> store,
  NextAyaAction action,
  NextDispatcher next,
) {
  store.dispatch(ResetTagsStatusAction());
  store.dispatch(ResetNotesStatusAction());
  next(action);
}

void _previousAyaMiddleware(
  Store<AppState> store,
  PreviousAyaAction action,
  NextDispatcher next,
) {
  store.dispatch(ResetTagsStatusAction());
  store.dispatch(ResetNotesStatusAction());
  next(action);
}

void _shareAyaReaderMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) async {
  String shareString = await QuranUtils.shareString(
    store.state.reader.currentSurahDetails().transliterationEn,
    store.state.reader.currentSurah,
    store.state.reader.currentAya,
  );
  Share.share(
    shareString,
  );
  QuranLogger.logAnalytics("share");
  next(action);
}

void _randomAyaReaderMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  try {
    int randomSurahIndex = Random().nextInt(114);
    int randomAyaIndex = Random().nextInt(
      store.state.reader.surahTitles[randomSurahIndex].totalVerses,
    );
    store.dispatch(
      SelectParticularAyaAction(
        surah: randomSurahIndex,
        aya: randomAyaIndex + 1,
      ),
    );
  } catch (_) {}
  next(action);
}

void _selectParticularAyaReaderMiddleware(
  Store<AppState> store,
  SelectParticularAyaAction action,
  NextDispatcher next,
) async {
  try {
    if (store.state.reader.surahTitles.isEmpty) {
      // not yet initialized
      var surahList = await NobleQuran.getSurahList();
      await store.dispatch(SetSurahListAction(
        surahs: surahList,
      ));

      // init words list if required
      List<List<NQWord>>? suraWords;
      if (store.state.reader.currentSurah != action.surah) {
        // we have a new surah, reload content
        suraWords = await NobleQuran.getSurahWordByWord(
          action.surah - 1,
        );
      }
      action = action.copyWith(
        words: suraWords,
      );
    }
  } catch (_) {}
  next(action);
}

void _selectSurahReaderMiddleware(
  Store<AppState> store,
  SelectSurahAction action,
  NextDispatcher next,
) async {
  try {
    List<List<NQWord>>? suraWords;
    if (store.state.reader.currentSurah != action.surah) {
      // we have a new surah, reload content
      suraWords = await NobleQuran.getSurahWordByWord(
        action.surah - 1,
      );
    }
    action = action.copyWith(
      words: suraWords,
    );
  } catch (_) {}
  next(action);
}
