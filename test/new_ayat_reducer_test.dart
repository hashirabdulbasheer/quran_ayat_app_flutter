import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/reader_screen_state.dart';
import 'package:redux/redux.dart';

void main() {
  test(
    'Init returns same state',
    () async {
      final store = Store<AppState>(
        appStateReducer,
        initialState: const AppState(),
      );

      await store.dispatch(InitializeReaderScreenAction());

      expect(
        store.state.reader,
        store.state.reader,
      );
    },
  );

  test(
    'Set surah titles action sets surah titles in state',
    () async {
      final store = Store<AppState>(
        appStateReducer,
        initialState: const AppState(),
      );

      NQSurahTitle surahTitle1 = NQSurahTitle(
        number: 1,
        name: "hashir1",
        translationEn: "Test1",
        transliterationEn: "Test1",
        totalVerses: 1,
        revelationType: RevelationType.MECCAN,
      );

      NQSurahTitle surahTitle2 = NQSurahTitle(
        number: 2,
        name: "hashir2",
        translationEn: "Test2",
        transliterationEn: "Test2",
        totalVerses: 2,
        revelationType: RevelationType.MEDINAN,
      );

      await store.dispatch(SetSurahListAction(surahs: [
        surahTitle1,
        surahTitle2,
      ]));

      expect(
        store.state.reader.surahTitles,
        [
          surahTitle1,
          surahTitle2,
        ],
      );
    },
  );

  test(
    'Set surah titles action sets current index to bookmarks if its already set',
    () async {
      final store = Store<AppState>(
        appStateReducer,
        initialState: const AppState(
          reader: ReaderScreenState(
            bookmarkState: SurahIndex(
              1,
              1,
            ),
          ),
        ),
      );

      await store.dispatch(SetSurahListAction(surahs: const []));

      expect(
        store.state.reader.surahTitles,
        List<NQSurahTitle>.empty(),
      );

      expect(
        store.state.reader.currentIndex,
        const SurahIndex(
          1,
          1,
        ),
      );
    },
  );

  test(
    'Set surah titles action doesnt affect current index if no bookmark is set',
    () async {
      final store = Store<AppState>(
        appStateReducer,
        initialState: const AppState(
          reader: ReaderScreenState(
            currentIndex: SurahIndex(
              1,
              2,
            ),
          ),
        ),
      );

      await store.dispatch(SetSurahListAction(surahs: const []));

      expect(
        store.state.reader.surahTitles,
        List<NQSurahTitle>.empty(),
      );

      expect(
        store.state.reader.currentIndex,
        store.state.reader.currentIndex,
      );
    },
  );
}
