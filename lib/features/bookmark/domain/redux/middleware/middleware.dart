import 'package:redux/redux.dart';

import '../../../../core/domain/app_state/app_state.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createReaderScreenMiddleware() {
  return [
    TypedMiddleware<AppState, UpdateBookmarkAction>(
      _updateBookmarkMiddleware,
    ),
  ];
}

void _updateBookmarkMiddleware(
  Store<AppState> store,
  UpdateBookmarkAction action,
  NextDispatcher next,
) {
  next(action);
}
