import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:quran_ayat/features/bookmark/domain/bookmarks_manager.dart';
import 'package:quran_ayat/features/bookmark/domain/interfaces/bookmark_interface.dart';

class _BookmarksMock extends QuranBookmarksInterface {
  final List<NQBookmark> bookmarks = [];

  @override
  Future<bool> clear() {
    bookmarks.clear();

    return Future.value(true);
  }

  @override
  Future<NQBookmark?> fetch() {
    if (bookmarks.isNotEmpty) {
      return Future.value(bookmarks.first);
    }

    return Future.value(null);
  }

  @override
  Future<bool> save(
    int sura,
    int aya,
  ) {
    bookmarks.add(NQBookmark(surah: sura, ayat: aya,));

    return Future.value(true);
  }
}

void main() {
  test(
    'Clear Local',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksMock(),
      );

      // Act
      await sut.localEngine.save(
        5,
        1,
      );
      await sut.localEngine.clear();
      NQBookmark? bookmark = await sut.localEngine.fetch();

      // Assert
      expect(
        bookmark,
        null,
      );
    },
  );

  test(
    'Clear Remote',
    () async {
      // Arrange
      _BookmarksMock local = _BookmarksMock();
      _BookmarksMock remote = _BookmarksMock();
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: local,
        remoteEngine: remote,
      );

      // Act
      await sut.remoteEngine?.save(
        5,
        2,
      );
      await sut.remoteEngine?.clear();
      NQBookmark? bookmark = await sut.remoteEngine?.fetch();

      // Assert
      expect(
        bookmark,
        null,
      );
    },
  );

  test(
    'Clear Remote With No Remote',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksMock(),
      );

      // Act
      await sut.remoteEngine?.save(
        5,
        2,
      );
      await sut.remoteEngine?.clear();
      NQBookmark? bookmark = await sut.remoteEngine?.fetch();

      // Assert
      expect(
        bookmark,
        null,
      );
    },
  );

  test(
    'Save and Fetch Local',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksMock(),
      );

      // Act
      await sut.localEngine.save(
        5,
        1,
      );
      NQBookmark? bookmark = await sut.localEngine.fetch();

      // Assert
      expect(
        bookmark != null,
        true,
      );

      expect(
        bookmark?.surah,
        5,
      );

      expect(
        bookmark?.ayat,
        1,
      );
    },
  );

  test(
    'Save Twice should save twice',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksMock(),
      );

      // Act
      await sut.localEngine.save(
        5,
        1,
      );
      await sut.localEngine.save(
        5,
        1,
      );

      // Assert
      expect(
        (sut.localEngine as _BookmarksMock).bookmarks.length == 2,
        true,
      );
    },
  );

  test(
    'Save and Fetch Remote',
    () async {
      // Arrange
      _BookmarksMock local = _BookmarksMock();
      _BookmarksMock remote = _BookmarksMock();
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: local,
        remoteEngine: remote,
      );

      // Act
      await sut.remoteEngine?.save(
        5,
        2,
      );
      NQBookmark? bookmark = await sut.remoteEngine?.fetch();

      // Assert
      expect(
        bookmark != null,
        true,
      );

      expect(
        bookmark?.surah,
        5,
      );

      expect(
        bookmark?.ayat,
        2,
      );
    },
  );

  test(
    'Save and Fetch Remote With No Remote',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksMock(),
      );

      // Act
      await sut.remoteEngine?.save(
        5,
        2,
      );
      NQBookmark? bookmark = await sut.remoteEngine?.fetch();

      // Assert
      expect(
        bookmark == null,
        true,
      );

      expect(
        bookmark?.surah,
        null,
      );

      expect(
        bookmark?.ayat,
        null,
      );
    },
  );
}
