import 'interfaces/bookmark_interface.dart';

class QuranBookmarksManager {
  final QuranBookmarksInterface localEngine;
  QuranBookmarksInterface? remoteEngine;

  QuranBookmarksManager({
    required this.localEngine,
    this.remoteEngine,
  });
}
