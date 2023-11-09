import 'package:redux/redux.dart';

import '../../redux/bookmark_state.dart';
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
  return state.copyWith(
    index: action.index,
  );
}

BookmarkState _initBookmarkReducer(
  BookmarkState state,
  InitBookmarkAction action,
) {
  return state.copyWith(
    index: action.index,
  );
}
