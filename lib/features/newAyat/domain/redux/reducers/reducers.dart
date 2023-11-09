import 'package:quran_ayat/features/bookmark/domain/redux/reducers/reducers.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../reader_screen_state.dart';

/// AYAT SCREEN REDUCER
///

Reducer<ReaderScreenState> readerScreenReducer =
    combineReducers<ReaderScreenState>([
  TypedReducer<ReaderScreenState, InitializeReaderScreenAction>(
    _initReaderScreenReducer,
  ),
  TypedReducer<ReaderScreenState, SetSurahListAction>(
    _setSurahTitlesReducer,
  ),
  TypedReducer<ReaderScreenState, SelectSurahAction>(
    _surahSelectedReducer,
  ),
  TypedReducer<ReaderScreenState, SelectAyaAction>(
    _ayaSelectedReducer,
  ),
  TypedReducer<ReaderScreenState, ShowLoadingAction>(
    _showLoadingReducer,
  ),
  TypedReducer<ReaderScreenState, HideLoadingAction>(
    _hideLoadingReducer,
  ),
  TypedReducer<ReaderScreenState, NextAyaAction>(
    _nextAyaReducer,
  ),
  TypedReducer<ReaderScreenState, PreviousAyaAction>(
    _previousAyaReducer,
  ),
  TypedReducer<ReaderScreenState, SetAudioContinuousPlayMode>(
    _audioContinuousModeReducer,
  ),
  TypedReducer<ReaderScreenState, SelectParticularAyaAction>(
    _particularAyaSelectedReducer,
  ),
  TypedReducer<ReaderScreenState, dynamic>(
    _allOtherReaderReducer,
  ),
]);

ReaderScreenState _allOtherReaderReducer(
  ReaderScreenState state,
  dynamic action,
) {
  return state.copyWith(
    bookmarkState: bookmarkReducer(
      state.bookmarkState,
      action,
    ),
  );
}

ReaderScreenState _initReaderScreenReducer(
  ReaderScreenState state,
  InitializeReaderScreenAction _,
) {
  return state;
}

ReaderScreenState _setSurahTitlesReducer(
  ReaderScreenState state,
  SetSurahListAction action,
) {
  return state.copyWith(
    surahTitles: action.surahs,
    currentSurah: state.bookmarkState.index?.sura ?? state.currentSurah,
    currentAya: state.bookmarkState.index?.aya ?? state.currentAya,
  );
}

ReaderScreenState _surahSelectedReducer(
  ReaderScreenState state,
  SelectSurahAction action,
) {
  int suraIndex = action.surah.abs();
  ReaderScreenState newState = state.copyWith(
    data: state.data.copyWith(
      words: action.words,
      translation: action.translation,
    ),
  );
  if (suraIndex >= 0 && suraIndex < 115) {
    return newState.copyWith(
      currentSurah: suraIndex - 1,
      currentAya: 1,
    );
  } else {
    return newState.copyWith(
      currentSurah: 0,
      currentAya: 1,
    );
  }
}

ReaderScreenState _ayaSelectedReducer(
  ReaderScreenState state,
  SelectAyaAction action,
) {
  int ayaIndex = action.aya.abs();
  if (ayaIndex < state.currentSurahDetails().totalVerses) {
    return state.copyWith(
      currentAya: ayaIndex,
    );
  } else {
    return state.copyWith(
      currentAya: 1,
    );
  }
}

ReaderScreenState _particularAyaSelectedReducer(
  ReaderScreenState state,
  SelectParticularAyaAction action,
) {
  int suraIndex = action.surah.abs() - 1;
  int ayaIndex = action.aya.abs();
  ReaderScreenState newState = state.copyWith(
    data: state.data.copyWith(
      words: action.words,
      translation: action.translation,
    ),
  );
  if (suraIndex > 114) {
    return newState.copyWith(
      currentSurah: 0,
      currentAya: 1,
    );
  } else if (ayaIndex > state.surahTitles[suraIndex].totalVerses) {
    return newState.copyWith(
      currentSurah: suraIndex,
      currentAya: 1,
    );
  }

  return newState.copyWith(
    currentSurah: suraIndex,
    currentAya: ayaIndex,
  );
}

ReaderScreenState _showLoadingReducer(
  ReaderScreenState state,
  ShowLoadingAction _,
) {
  return state.copyWith(
    isLoading: true,
  );
}

ReaderScreenState _hideLoadingReducer(
  ReaderScreenState state,
  HideLoadingAction _,
) {
  return state.copyWith(
    isLoading: false,
  );
}

ReaderScreenState _nextAyaReducer(
  ReaderScreenState state,
  NextAyaAction _,
) {
  int totalVerses = state.currentSurahDetails().totalVerses;
  int nextAyat = state.currentAya + 1;
  if (nextAyat <= totalVerses) {
    return state.copyWith(
      currentAya: nextAyat,
    );
  }

  // sura completed - stop continuous play
  return state.copyWith(
    isAudioContinuousModeEnabled: false,
  );
}

ReaderScreenState _previousAyaReducer(
  ReaderScreenState state,
  PreviousAyaAction _,
) {
  int prevAyat = state.currentAya - 1;
  if (prevAyat > 0) {
    return state.copyWith(
      currentAya: prevAyat,
    );
  }

  return state;
}

ReaderScreenState _audioContinuousModeReducer(
  ReaderScreenState state,
  SetAudioContinuousPlayMode action,
) {
  return state.copyWith(
    isAudioContinuousModeEnabled: action.isEnabled,
  );
}
