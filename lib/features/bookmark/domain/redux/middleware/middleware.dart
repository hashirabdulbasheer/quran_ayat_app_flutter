import 'package:quran_ayat/features/bookmark/data/bookmarks_local_impl.dart';
import 'package:quran_ayat/features/bookmark/data/firebase_bookmarks_impl.dart';
import 'package:quran_ayat/models/qr_user_model.dart';
import 'package:redux/redux.dart';

import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createBookmarkMiddleware() {
  return [
    TypedMiddleware<AppState, SaveBookmarkAction>(
      _saveBookmarkMiddleware,
    ),
    TypedMiddleware<AppState, InitBookmarkAction>(
      _initBookmarkMiddleware,
    ),
    TypedMiddleware<AppState, SetBookmarkAction>(
      _setBookmarkMiddleware,
    ),
  ];
}

void _initBookmarkMiddleware(
  Store<AppState> store,
  InitBookmarkAction action,
  NextDispatcher next,
) {
  QuranLocalBookmarksEngine local = QuranLocalBookmarksEngine();
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    // logged in - try remote
    QuranFirebaseBookmarksEngine remote =
        QuranFirebaseBookmarksEngine(userId: user.uid);
    remote.fetch().then((bookmark) {
      if (bookmark != null) {
        store.dispatch(SetBookmarkAction(
          surahIndex: bookmark.surah,
          ayaIndex: bookmark.ayat,
        ));
      }
    });
  } else {
    // try to get bookmark from local
    local.fetch().then((bookmark) {
      if (bookmark != null) {
        store.dispatch(SetBookmarkAction(
          surahIndex: bookmark.surah,
          ayaIndex: bookmark.ayat,
        ));
      }
    });
  }

  next(action);
}

void _saveBookmarkMiddleware(
  Store<AppState> store,
  SaveBookmarkAction action,
  NextDispatcher next,
) {
  QuranLocalBookmarksEngine local = QuranLocalBookmarksEngine();
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    // logged in
    QuranFirebaseBookmarksEngine remote =
        QuranFirebaseBookmarksEngine(userId: user.uid);
    remote.save(
      action.surahIndex,
      action.ayaIndex,
    );
  }
  local.save(
    action.surahIndex,
    action.ayaIndex,
  );
  next(action);
}

void _setBookmarkMiddleware(
  Store<AppState> store,
  SetBookmarkAction action,
  NextDispatcher next,
) {
  next(action);
}
