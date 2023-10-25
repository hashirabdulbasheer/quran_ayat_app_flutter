import 'package:noble_quran/models/bookmark.dart';
import 'package:quran_ayat/features/bookmark/data/bookmarks_local_impl.dart';
import 'package:quran_ayat/features/bookmark/data/firebase_bookmarks_impl.dart';
import 'package:quran_ayat/models/qr_user_model.dart';
import 'package:redux/redux.dart';

import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../newAyat/domain/redux/actions/actions.dart';
import '../actions/actions.dart';

List<Middleware<AppState>> createBookmarkMiddleware() {
  return [
    TypedMiddleware<AppState, SaveBookmarkAction>(
      _saveBookmarkMiddleware,
    ),
    TypedMiddleware<AppState, InitBookmarkAction>(
      _initBookmarkMiddleware,
    ),
  ];
}

void _initBookmarkMiddleware(
  Store<AppState> store,
  InitBookmarkAction action,
  NextDispatcher next,
) async {
  QuranLocalBookmarksEngine local = QuranLocalBookmarksEngine();
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    // logged in -> with network -> try remote
    // merge if there is a difference between remote and local
    QuranFirebaseBookmarksEngine remote =
        QuranFirebaseBookmarksEngine(userId: user.uid);
    NQBookmark? remoteBookmark = await remote.fetch();
    NQBookmark? localBookmark = await local.fetch();
    NQBookmark? merged;
    if (remoteBookmark != null && localBookmark != null) {
      int remoteLastUpdatedTime = remoteBookmark.seconds ?? 0;
      int localLastUpdatedTime = localBookmark.seconds ?? 0;
      if (remoteLastUpdatedTime >= localLastUpdatedTime) {
        // remote was updated later, so thats latest and use that
        merged = remoteBookmark;
      } else {
        // local was latest, so use that, also save it to remote
        merged = localBookmark;
      }
    } else if (remoteBookmark != null) {
      merged = remoteBookmark;
    } else if (localBookmark != null) {
      merged = localBookmark;
    }
    if (merged != null) {
      store.dispatch(SaveBookmarkAction(
        surahIndex: merged.surah,
        ayaIndex: merged.ayat,
      ));
    }
    next(action);
  } else {
    // user not logged in -> try local
    NQBookmark? localBookmark = await local.fetch();
    if (localBookmark != null) {
      store.dispatch(SaveBookmarkAction(
        surahIndex: localBookmark.surah,
        ayaIndex: localBookmark.ayat,
      ));
    }
  }
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
