import 'package:redux/redux.dart';

import '../../../data/surah_index.dart';
import '../actions/actions.dart';
import '../actions/bookmark_actions.dart';
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
  TypedReducer<ReaderScreenState, SaveBookmarkAction>(
    _saveBookmarkReducer,
  ),
  TypedReducer<ReaderScreenState, InitBookmarkAction>(
    _initBookmarkReducer,
  ),
  TypedReducer<ReaderScreenState, ToggleHeaderVisibilityAction>(
    _toggleHeaderVisibilityReducer,
  ),
  TypedReducer<ReaderScreenState, dynamic>(
    _allOtherReaderReducer,
  ),
]);

ReaderScreenState _allOtherReaderReducer(
  ReaderScreenState state,
  dynamic action,
) {
  return state;
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
    currentIndex: state.bookmarkState ?? state.currentIndex,
  );
}

ReaderScreenState _surahSelectedReducer(
  ReaderScreenState state,
  SelectSurahAction action,
) {
  int suraIndex = action.index.sura.abs();
  ReaderScreenState newState = state.copyWith(
    data: action.data,
  );
  if (suraIndex >= 0 && suraIndex < 114) {
    return newState.copyWith(
      currentIndex: action.index,
    );
  } else {
    return newState.copyWith(
      currentIndex: SurahIndex.defaultIndex,
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
      currentIndex: state.currentIndex.copyWith(aya: ayaIndex),
    );
  } else {
    return state.copyWith(
      currentIndex: state.currentIndex.copyWith(aya: 1),
    );
  }
}

ReaderScreenState _particularAyaSelectedReducer(
  ReaderScreenState state,
  SelectParticularAyaAction action,
) {
  int suraIndex = action.index.sura.abs();
  int ayaIndex = action.index.aya.abs();
  ReaderScreenState newState = state.copyWith(
    data: action.data,
  );
  if (suraIndex > 114) {
    return newState.copyWith(
      currentIndex: SurahIndex.defaultIndex,
    );
  } else if (ayaIndex >= state.surahTitles[suraIndex].totalVerses) {
    return newState;
  }

  return newState.copyWith(
    currentIndex: action.index,
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
  int totalVerses = state.currentSurahDetails().totalVerses - 1;
  int nextAyat = state.currentIndex.aya + 1;
  if (nextAyat <= totalVerses) {
    return state.copyWith(
      currentIndex: state.currentIndex.next(),
    );
  }

  // sura completed - stop continuous play
  return state;
}

ReaderScreenState _previousAyaReducer(
  ReaderScreenState state,
  PreviousAyaAction _,
) {
  return state.copyWith(
    currentIndex: state.currentIndex.previous(),
  );
}

ReaderScreenState _audioContinuousModeReducer(
  ReaderScreenState state,
  SetAudioContinuousPlayMode action,
) {
  return state;
}

ReaderScreenState _saveBookmarkReducer(
  ReaderScreenState state,
  SaveBookmarkAction action,
) {
  return state.copyWith(
    bookmarkState: action.index,
  );
}

ReaderScreenState _initBookmarkReducer(
  ReaderScreenState state,
  InitBookmarkAction action,
) {
  return state.copyWith(
    bookmarkState: action.index,
  );
}

ReaderScreenState _toggleHeaderVisibilityReducer(
  ReaderScreenState state,
  ToggleHeaderVisibilityAction action,
) {
  return state.copyWith(
    isHeaderVisible: !state.isHeaderVisible,
  );
}
