import 'package:noble_quran/models/bookmark.dart';
import '../data/firebase_bookmarks_impl.dart';
import '../data/bookmarks_local_impl.dart';

class QuranBookmarksManager {
  QuranBookmarksManager._privateConstructor();

  static final QuranBookmarksManager instance =
      QuranBookmarksManager._privateConstructor();

  Future<bool> clearLocal() async {
    return await QuranLocalBookmarksEngine.instance.clear();
  }

  Future<bool> clearRemote() async {
    return await QuranFirebaseBookmarksEngine.instance.clear();
  }

  Future<NQBookmark?> fetchLocal() async {
    return await QuranLocalBookmarksEngine.instance.fetch();
  }

  Future<NQBookmark?> fetchRemote() async {
    return await QuranFirebaseBookmarksEngine.instance.fetch();
  }

  Future<bool> saveLocal(
    int sura,
    int aya,
  ) async {
    return await QuranLocalBookmarksEngine.instance.save(
      sura,
      aya,
    );
  }

  Future<bool> saveRemote(
    int sura,
    int aya,
  ) async {
    return await QuranFirebaseBookmarksEngine.instance.save(
      sura,
      aya,
    );
  }
}
