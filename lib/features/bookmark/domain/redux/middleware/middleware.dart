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
    // local is given precedence over remote and remote gets overridden by local
    QuranFirebaseBookmarksEngine remote =
        QuranFirebaseBookmarksEngine(userId: user.uid);
    NQBookmark? remoteBookmark = await remote.fetch();
    NQBookmark? localBookmark = await local.fetch();
    if (remoteBookmark != null && localBookmark != null) {
      // save local to remote as well
      store.dispatch(SaveBookmarkAction(
        surahIndex: localBookmark.surah,
        ayaIndex: localBookmark.ayat,
      ));
      store.dispatch(
        SelectParticularAyaAction(
          surah: localBookmark.surah,
          aya: localBookmark.ayat,
        ),
      );
    } else if (remoteBookmark != null) {
      // save remote to local as well
      store.dispatch(SaveBookmarkAction(
        surahIndex: remoteBookmark.surah,
        ayaIndex: remoteBookmark.ayat,
      ));
      store.dispatch(
        SelectParticularAyaAction(
          surah: remoteBookmark.surah,
          aya: remoteBookmark.ayat,
        ),
      );
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
