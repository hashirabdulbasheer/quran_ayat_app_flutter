import 'package:redux/redux.dart';
import '../actions/actions.dart';
import '../bookmark_state.dart';

Reducer<BookmarkState> readerScreenReducer = combineReducers<BookmarkState>([
  TypedReducer<BookmarkState, UpdateBookmarkAction>(
    _updateBookmarkReducer,
  ),
]);

BookmarkState _updateBookmarkReducer(
  BookmarkState state,
  UpdateBookmarkAction action,
) {
  return state;
}
