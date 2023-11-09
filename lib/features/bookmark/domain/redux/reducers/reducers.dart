import 'package:redux/redux.dart';

import '../../../../newAyat/domain/redux/reader_screen_state.dart';
import '../actions/actions.dart';

Reducer<BookmarkState> bookmarkReducer = combineReducers<BookmarkState>([
  TypedReducer<BookmarkState, SaveBookmarkAction>(
    _saveBookmarkReducer,
  ),
  TypedReducer<BookmarkState, InitBookmarkAction>(
    _initBookmarkReducer,
  ),
]);

BookmarkState _saveBookmarkReducer(
  BookmarkState state,
  SaveBookmarkAction action,
) {
  return action.index;
}

BookmarkState _initBookmarkReducer(
  BookmarkState state,
  InitBookmarkAction action,
) {
  return state;
}
