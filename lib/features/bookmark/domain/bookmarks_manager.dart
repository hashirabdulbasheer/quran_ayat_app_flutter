import 'package:noble_quran/models/bookmark.dart';

import 'interfaces/bookmark_interface.dart';

class QuranBookmarksManager {
  final QuranBookmarksInterface localEngine;
  QuranBookmarksInterface? remoteEngine;

  QuranBookmarksManager({
    required this.localEngine,
    this.remoteEngine,
  });

  Future<NQBookmark?> fetch() async {
    if (remoteEngine != null) {
      return remoteEngine?.fetch();
    }

    return localEngine.fetch();
  }
}
