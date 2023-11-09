import 'dart:math';

import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
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
import '../../../data/quran_data.dart';
import '../../../data/surah_index.dart';
import '../actions/actions.dart';
import '../actions/bookmark_actions.dart';

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
  // Initialize quran data
  QuranData data = await _loadQuranData(SurahIndex.defaultIndex);
  store.dispatch(SelectParticularAyaAction(
    index: SurahIndex.defaultIndex,
    words: data.words,
    translation: data.translation,
  ));
  // Load bookmarks
  store.dispatch(InitBookmarkAction());

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
    store.state.reader.currentIndex.sura,
    store.state.reader.currentIndex.aya,
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
        ) +
        1;
    store.dispatch(
      SelectParticularAyaAction(
        index: SurahIndex(
          randomSurahIndex,
          randomAyaIndex,
        ),
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
    }

    if (store.state.reader.currentIndex != action.index) {
      QuranData date = await _loadQuranData(action.index);
      action = action.copyWith(
        words: date.words,
        translation: date.translation,
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
    if (store.state.reader.currentIndex != action.index) {
      QuranData date = await _loadQuranData(action.index);
      action = action.copyWith(
        words: date.words,
        translation: date.translation,
      );
    }
  } catch (_) {}
  next(action);
}

Future<QuranData> _loadQuranData(SurahIndex surahIndex) async {
  // Initialize surah words
  List<List<NQWord>>? suraWords = await NobleQuran.getSurahWordByWord(
    surahIndex.sura,
  );
  // Initialize translation
  NQTranslation currentTranslationType =
      await QuranSettingsManager.instance.getTranslation();
  NQSurah translation = await NobleQuran.getTranslationString(
    surahIndex.sura,
    currentTranslationType,
  );

  return QuranData(
    words: suraWords,
    translation: translation,
  );
}
