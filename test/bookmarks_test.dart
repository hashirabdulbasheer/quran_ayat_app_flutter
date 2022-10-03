import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:quran_ayat/features/bookmark/domain/bookmarks_manager.dart';
import 'package:quran_ayat/features/bookmark/domain/interfaces/bookmark_interface.dart';

class _BookmarksSpy extends QuranBookmarksInterface {
  int _sura = -1;
  int _aya = -1;

  @override
  Future<bool> clear() {
    _sura = -1;
    _aya = -1;

    return Future.value(true);
  }

  @override
  Future<NQBookmark?> fetch() {

    return Future.value(NQBookmark(
      surah: _sura,
      ayat: _aya,
    ));
  }

  @override
  Future<bool> save(
    int sura,
    int aya,
  ) {
    _sura = sura;
    _aya = aya;

    return Future.value(true);
  }
}

void main() {
  test(
    'Clear Local',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksSpy(),
      );

      // Act
      await sut.saveLocal(
        5,
        1,
      );
      await sut.clearLocal();
      NQBookmark? bookmark = await sut.fetchLocal();

      // Assert
      expect(
        bookmark?.surah,
        -1,
      );
      expect(
        bookmark?.ayat,
        -1,
      );
    },
  );

  test(
    'Clear Remote',
    () async {
      // Arrange
      _BookmarksSpy local = _BookmarksSpy();
      _BookmarksSpy remote = _BookmarksSpy();
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: local,
        remoteEngine: remote,
      );

      // Act
      await sut.saveRemote(
        5,
        2,
      );
      await sut.clearRemote();
      NQBookmark? bookmark = await sut.fetchRemote();

      // Assert
      expect(
        bookmark?.surah,
        -1,
      );
      expect(
        bookmark?.ayat,
        -1,
      );
    },
  );

  test(
    'Clear Remote With No Remote',
        () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksSpy(),
      );

      // Act
      await sut.saveRemote(
        5,
        2,
      );
      await sut.clearRemote();
      NQBookmark? bookmark = await sut.fetchRemote();

      // Assert
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

  test(
    'Save and Fetch Local',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksSpy(),
      );

      // Act
      await sut.saveLocal(
        5,
        1,
      );
      NQBookmark? bookmark = await sut.fetchLocal();

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
    'Save and Fetch Remote',
    () async {
      // Arrange
      _BookmarksSpy local = _BookmarksSpy();
      _BookmarksSpy remote = _BookmarksSpy();
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: local,
        remoteEngine: remote,
      );

      // Act
      await sut.saveRemote(
        5,
        2,
      );
      NQBookmark? bookmark = await sut.fetchRemote();

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
        localEngine: _BookmarksSpy(),
      );

      // Act
      await sut.saveRemote(
        5,
        2,
      );
      NQBookmark? bookmark = await sut.fetchRemote();

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
