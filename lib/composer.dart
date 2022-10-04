import 'package:quran_ayat/models/qr_user_model.dart';
import 'package:quran_ayat/quran_ayat_screen.dart';

import 'features/auth/domain/auth_factory.dart';
import 'features/bookmark/data/bookmarks_local_impl.dart';
import 'features/bookmark/data/firebase_bookmarks_impl.dart';
import 'features/bookmark/domain/bookmarks_manager.dart';

class QuranComposer {
  static QuranAyatScreen composeAyatScreen({
    int? suraIndex,
    int? ayaIndex,
  }) {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      return QuranAyatScreen(
        surahIndex: suraIndex,
        ayaIndex: ayaIndex,
        bookmarksManager: QuranBookmarksManager(
          localEngine: QuranLocalBookmarksEngine(),
          remoteEngine: QuranFirebaseBookmarksEngine(
            userId: user.uid,
          ),
        ),
      );
    }

    return QuranAyatScreen(
      bookmarksManager: QuranBookmarksManager(
        localEngine: QuranLocalBookmarksEngine(),
      ),
    );
  }
}
