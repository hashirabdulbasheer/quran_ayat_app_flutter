import 'package:noble_quran/models/bookmark.dart';
import 'interfaces/bookmark_interface.dart';

class QuranBookmarksManager {
  QuranBookmarksInterface localEngine;
  QuranBookmarksInterface remoteEngine;

  QuranBookmarksManager({
    required this.localEngine,
    required this.remoteEngine,
  });

  Future<bool> clearLocal() async {
    return await localEngine.clear();
  }

  Future<bool> clearRemote() async {
    return await remoteEngine.clear();
  }

  Future<NQBookmark?> fetchLocal() async {
    return await localEngine.fetch();
  }

  Future<NQBookmark?> fetchRemote() async {
    return await remoteEngine.fetch();
  }

  Future<bool> saveLocal(
    int sura,
    int aya,
  ) async {
    return await localEngine.save(
      sura,
      aya,
    );
  }

  Future<bool> saveRemote(
    int sura,
    int aya,
  ) async {
    return await remoteEngine.save(
      sura,
      aya,
    );
  }
}
