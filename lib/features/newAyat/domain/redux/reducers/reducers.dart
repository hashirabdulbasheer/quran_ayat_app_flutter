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
]);

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
    currentSurah: 0,
    currentAya: 1,
  );
}

ReaderScreenState _surahSelectedReducer(
  ReaderScreenState state,
  SelectSurahAction action,
) {
  return state.copyWith(
    currentSurah: action.surah - 1,
    currentAya: 1,
  );
}

ReaderScreenState _ayaSelectedReducer(
  ReaderScreenState state,
  SelectAyaAction action,
) {
  return state.copyWith(
    currentAya: action.aya,
  );
}

ReaderScreenState _showLoadingReducer(
  ReaderScreenState state,
  ShowLoadingAction action,
) {
  return state.copyWith(
    isLoading: true,
  );
}

ReaderScreenState _hideLoadingReducer(
  ReaderScreenState state,
  HideLoadingAction action,
) {
  return state.copyWith(
    isLoading: false,
  );
}
