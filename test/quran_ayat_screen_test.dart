import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:quran_ayat/features/bookmark/domain/bookmarks_manager.dart';
import 'package:quran_ayat/features/bookmark/domain/interfaces/bookmark_interface.dart';
import 'package:quran_ayat/quran_ayat_screen.dart';

class MockLocalBookmarksEngine implements QuranBookmarksInterface {
  @override
  Future<bool> clear() {
    return Future.value(true);
  }

  @override
  Future<NQBookmark?> fetch() {
    return Future.value(null);
  }

  @override
  Future<bool> save(
    int sura,
    int aya,
  ) {
    return Future.value(true);
  }
}

void main() {
  testWidgets(
    'MyWidget',
    (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(QuranAyatScreen(
        bookmarksManager: QuranBookmarksManager(
          localEngine: MockLocalBookmarksEngine(),
        ),
      ));
      expect(
        find.text('Quran'),
        findsOneWidget,
      );
    },
  );
}
