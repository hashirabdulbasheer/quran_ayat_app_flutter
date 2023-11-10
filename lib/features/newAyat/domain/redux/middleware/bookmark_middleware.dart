import 'package:noble_quran/models/bookmark.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:redux/redux.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../bookmark/data/bookmarks_local_impl.dart';
import '../../../../bookmark/data/firebase_bookmarks_impl.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../actions/actions.dart';
import '../actions/bookmark_actions.dart';

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
  NQBookmark? localBookmark = await local.fetch();
  if (localBookmark != null) {
    // local bookmark is always given preference
    action = action.copyWith(
      index: SurahIndex.fromBookmark(localBookmark),
    );
    store.dispatch(
      SelectParticularAyaAction(
        index: SurahIndex(
          localBookmark.surah,
          localBookmark.ayat,
        ),
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
          index: SurahIndex.fromBookmark(remoteBookmark),
        );
        store.dispatch(
          SelectParticularAyaAction(
            index: SurahIndex(
              remoteBookmark.surah,
              remoteBookmark.ayat,
            ),
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
      action.index.sura,
      action.index.aya,
    );
  }
  local.save(
    action.index.sura,
    action.index.aya,
  );
  next(action);
}
