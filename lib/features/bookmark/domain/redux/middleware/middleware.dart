import 'package:noble_quran/models/bookmark.dart';
import 'package:redux/redux.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../newAyat/domain/redux/actions/actions.dart';
import '../../../data/bookmarks_local_impl.dart';
import '../../../data/firebase_bookmarks_impl.dart';
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
  if (store.state.reader.currentSurah != 0 ||
      store.state.reader.currentAya != 1) {
    // only update bookmark if we are on 1:1
    // this is so that we don't replace another aya with bookmark
    return;
  }
  QuranLocalBookmarksEngine local = QuranLocalBookmarksEngine();
  NQBookmark? localBookmark = await local.fetch();
  if (localBookmark != null) {
    // local bookmark is always given preference
    action = action.copyWith(
      surahIndex: localBookmark.surah,
      ayaIndex: localBookmark.ayat,
    );
    store.dispatch(
      SelectParticularAyaAction(
        surah: localBookmark.surah,
        aya: localBookmark.ayat,
      ),
    );
  } else {
    // no local available, try remote
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      // logged in -> with network -> try remote
      QuranFirebaseBookmarksEngine remote =
          QuranFirebaseBookmarksEngine(userId: user.uid);
      NQBookmark? remoteBookmark = await remote.fetch();
      if (remoteBookmark != null) {
        // save remote in local, as well, always save in human readable surah
        // index, hence +1
        local.save(
          remoteBookmark.surah + 1,
          remoteBookmark.ayat,
        );
        action = action.copyWith(
          surahIndex: remoteBookmark.surah,
          ayaIndex: remoteBookmark.ayat,
        );
        store.dispatch(
          SelectParticularAyaAction(
            surah: remoteBookmark.surah,
            aya: remoteBookmark.ayat,
          ),
        );
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
  // Always save bookmarks as human readable indices, 1 for first chapter etc.
  QuranLocalBookmarksEngine local = QuranLocalBookmarksEngine();
  QuranUser? user = QuranAuthFactory.engine.getUser();
  if (user != null) {
    // logged in
    QuranFirebaseBookmarksEngine remote =
        QuranFirebaseBookmarksEngine(userId: user.uid);
    remote.save(
      action.surahIndex + 1,
      action.ayaIndex,
    );
  }
  local.save(
    action.surahIndex + 1,
    action.ayaIndex,
  );
  next(action);
}
