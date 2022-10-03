
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:quran_ayat/features/bookmark/domain/bookmarks_manager.dart';
import 'package:quran_ayat/features/bookmark/domain/interfaces/bookmark_interface.dart';

class _BookmarksLocalSpy extends QuranBookmarksInterface {
  int numOfTimesClearCalled = 0;
  int numOfTimesFetchCalled = 0;
  int numOfTimesSaveCalled = 0;

  @override
  Future<bool> clear() {
    numOfTimesClearCalled++;

    return Future.value(true);
  }

  @override
  Future<NQBookmark?> fetch() {
    numOfTimesFetchCalled++;

    return Future.value(NQBookmark(
      surah: 1,
      ayat: 2,
    ));
  }

  @override
  Future<bool> save(
    int sura,
    int aya,
  ) {
    numOfTimesSaveCalled++;

    return Future.value(true);
  }
}

class _BookmarksRemoteSpy extends QuranBookmarksInterface {
  int numOfTimesClearCalled = 0;
  int numOfTimesFetchCalled = 0;
  int numOfTimesSaveCalled = 0;

  @override
  Future<bool> clear() {
    numOfTimesClearCalled++;

    return Future.value(true);
  }

  @override
  Future<NQBookmark?> fetch() {
    numOfTimesFetchCalled++;

    return Future.value(NQBookmark(
      surah: 2,
      ayat: 1,
    ));
  }

  @override
  Future<bool> save(
    int sura,
    int aya,
  ) {
    numOfTimesSaveCalled++;

    return Future.value(true);
  }
}

void main() {
  test(
    'Clear Local',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksLocalSpy(),
        remoteEngine: _BookmarksRemoteSpy(),
      );

      // Act
      await sut.clearLocal();

      // Assert
      expect(
        (sut.localEngine as _BookmarksLocalSpy).numOfTimesClearCalled,
        1,
      );
      expect(
        (sut.remoteEngine as _BookmarksRemoteSpy).numOfTimesClearCalled,
        0,
      );
    },
  );

  test(
    'Clear Remote',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksLocalSpy(),
        remoteEngine: _BookmarksRemoteSpy(),
      );

      // Act
      await sut.clearRemote();

      // Assert
      expect(
        (sut.localEngine as _BookmarksLocalSpy).numOfTimesClearCalled,
        0,
      );
      expect(
        (sut.remoteEngine as _BookmarksRemoteSpy).numOfTimesClearCalled,
        1,
      );
    },
  );

  test(
    'Fetch Local',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksLocalSpy(),
        remoteEngine: _BookmarksRemoteSpy(),
      );

      // Act
      NQBookmark? bookmark = await sut.fetchLocal();

      // Assert
      expect(
        (sut.localEngine as _BookmarksLocalSpy).numOfTimesFetchCalled,
        1,
      );
      expect(
        (sut.remoteEngine as _BookmarksRemoteSpy).numOfTimesFetchCalled,
        0,
      );

      expect(
        bookmark != null,
        true,
      );

      expect(
        bookmark?.surah,
        1,
      );

      expect(
        bookmark?.ayat,
        2,
      );
    },
  );

  test(
    'Fetch Remote',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksLocalSpy(),
        remoteEngine: _BookmarksRemoteSpy(),
      );

      // Act
      NQBookmark? bookmark = await sut.fetchRemote();

      // Assert
      expect(
        (sut.localEngine as _BookmarksLocalSpy).numOfTimesFetchCalled,
        0,
      );
      expect(
        (sut.remoteEngine as _BookmarksRemoteSpy).numOfTimesFetchCalled,
        1,
      );
      expect(
        bookmark != null,
        true,
      );

      expect(
        bookmark?.surah,
        2,
      );

      expect(
        bookmark?.ayat,
        1,
      );
    },
  );

  test(
    'Save Local',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksLocalSpy(),
        remoteEngine: _BookmarksRemoteSpy(),
      );

      // Act
      await sut.saveLocal(
        1,
        1,
      );

      // Assert
      expect(
        (sut.localEngine as _BookmarksLocalSpy).numOfTimesSaveCalled,
        1,
      );
      expect(
        (sut.remoteEngine as _BookmarksRemoteSpy).numOfTimesSaveCalled,
        0,
      );
    },
  );

  test(
    'Save Remote',
    () async {
      // Arrange
      QuranBookmarksManager sut = QuranBookmarksManager(
        localEngine: _BookmarksLocalSpy(),
        remoteEngine: _BookmarksRemoteSpy(),
      );

      // Act
      await sut.saveRemote(
        1,
        1,
      );

      // Assert
      expect(
        (sut.localEngine as _BookmarksLocalSpy).numOfTimesSaveCalled,
        0,
      );
      expect(
        (sut.remoteEngine as _BookmarksRemoteSpy).numOfTimesSaveCalled,
        1,
      );
    },
  );
}
