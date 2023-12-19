import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/data/quran_data.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/reader_screen_state.dart';
import 'package:redux/redux.dart';

void main() {
  group(
    'InitializeReaderScreenAction',
    () {
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
    },
  );

  group(
    'SetSurahListAction',
    () {
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
    },
  );

  group(
    'SelectSurahAction',
    () {
      test(
        'Set select surah action sets data and index for the surah in state',
        () async {
          final store = Store<AppState>(
            appStateReducer,
            initialState: const AppState(),
          );

          List<List<NQWord>> words = [
            [
              NQWord(
                word: 1,
                tr: "tr1",
                aya: 1,
                sura: 1,
                ar: "ar1",
              ),
              NQWord(
                word: 2,
                tr: "tr2",
                aya: 2,
                sura: 2,
                ar: "ar2",
              ),
            ],
          ];

          Map<NQTranslation, NQSurah?> translationMap = {};
          translationMap[NQTranslation.wahiduddinkhan] = NQSurah(
            aya: [],
            index: "1",
            name: "test1",
          );

          NQSurah transliteration = NQSurah(
            aya: [],
            index: "2",
            name: "test2",
          );

          // final Map<NQTranslation, NQSurah?> translationMap;
          // final NQSurah? transliteration
          QuranData data = QuranData(
            words: words,
            translationMap: translationMap,
            transliteration: transliteration,
          );

          await store.dispatch(SelectSurahAction(
            index: const SurahIndex(
              1,
              1,
            ),
            data: data,
          ));

          expect(
            store.state.reader.data,
            data,
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
        'Set select surah action sets index to default surah index if invalid',
        () async {
          final store = Store<AppState>(
            appStateReducer,
            initialState: const AppState(),
          );

          await store.dispatch(SelectSurahAction(
            index: const SurahIndex(
              900,
              1,
            ),
            data: null,
          ));

          expect(
            store.state.reader.data,
            const QuranData(),
          );

          expect(
            store.state.reader.currentIndex,
            SurahIndex.defaultIndex,
          );
        },
      );
    },
  );

  group(
    'SelectAyaAction',
    () {
      test(
        'Select aya action sets aya index in state',
        () async {
          NQSurahTitle surahTitle = NQSurahTitle(
            number: 0,
            name: "hashir1",
            translationEn: "Test1",
            transliterationEn: "Test1",
            totalVerses: 200,
            revelationType: RevelationType.MECCAN,
          );

          final store = Store<AppState>(
            appStateReducer,
            initialState: AppState(
              reader: ReaderScreenState(
                surahTitles: [surahTitle],
                currentIndex: const SurahIndex(
                  0,
                  1,
                ),
              ),
            ),
          );

          await store.dispatch(SelectAyaAction(
            aya: 100,
          ));

          expect(
            store.state.reader.currentIndex,
            const SurahIndex(
              0,
              100,
            ),
          );
        },
      );

      test(
        'Select invalid aya action sets aya index as 1 in state',
        () async {
          NQSurahTitle surahTitle = NQSurahTitle(
            number: 0,
            name: "hashir1",
            translationEn: "Test1",
            transliterationEn: "Test1",
            totalVerses: 200,
            revelationType: RevelationType.MECCAN,
          );

          final store = Store<AppState>(
            appStateReducer,
            initialState: AppState(
              reader: ReaderScreenState(
                surahTitles: [surahTitle],
                currentIndex: const SurahIndex(
                  0,
                  1,
                ),
              ),
            ),
          );

          await store.dispatch(SelectAyaAction(
            aya: 500,
          ));

          expect(
            store.state.reader.currentIndex,
            const SurahIndex(
              0,
              1,
            ),
          );
        },
      );

      test(
        'Select negative aya action sets aya index as 1 in state',
        () async {
          NQSurahTitle surahTitle = NQSurahTitle(
            number: 0,
            name: "hashir1",
            translationEn: "Test1",
            transliterationEn: "Test1",
            totalVerses: 200,
            revelationType: RevelationType.MECCAN,
          );

          final store = Store<AppState>(
            appStateReducer,
            initialState: AppState(
              reader: ReaderScreenState(
                surahTitles: [surahTitle],
                currentIndex: const SurahIndex(
                  0,
                  1,
                ),
              ),
            ),
          );

          await store.dispatch(SelectAyaAction(
            aya: -1,
          ));

          expect(
            store.state.reader.currentIndex,
            const SurahIndex(
              0,
              1,
            ),
          );
        },
      );
    },
  );

  group(
    'SelectParticularAyaAction',
    () {
      test(
        'Select Particular aya action sets sura and aya index in state',
        () async {
          NQSurahTitle surahTitle = NQSurahTitle(
            number: 0,
            name: "hashir1",
            translationEn: "Test1",
            transliterationEn: "Test1",
            totalVerses: 200,
            revelationType: RevelationType.MECCAN,
          );

          final store = Store<AppState>(
            appStateReducer,
            initialState: AppState(
              reader: ReaderScreenState(
                surahTitles: [surahTitle],
                currentIndex: const SurahIndex(
                  0,
                  1,
                ),
              ),
            ),
          );

          await store.dispatch(SelectParticularAyaAction(
              index: const SurahIndex(
            1,
            1,
          ),));

          expect(
            store.state.reader.currentIndex,
            const SurahIndex(
              0,
              1,
            ),
          );
        },
      );

      test(
        'Select Particular aya action with invalid surah index sets default sura index',
            () async {
          NQSurahTitle surahTitle = NQSurahTitle(
            number: 0,
            name: "hashir1",
            translationEn: "Test1",
            transliterationEn: "Test1",
            totalVerses: 200,
            revelationType: RevelationType.MECCAN,
          );

          final store = Store<AppState>(
            appStateReducer,
            initialState: AppState(
              reader: ReaderScreenState(
                surahTitles: [surahTitle],
                currentIndex: const SurahIndex(
                  0,
                  1,
                ),
              ),
            ),
          );

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              999,
              1,
            ),));

          expect(
            store.state.reader.currentIndex,
            SurahIndex.defaultIndex,
          );
        },
      );

      test(
        'Select Particular aya action with invalid aya index doesnt change aya index',
            () async {
          NQSurahTitle surahTitle = NQSurahTitle(
            number: 0,
            name: "hashir1",
            translationEn: "Test1",
            transliterationEn: "Test1",
            totalVerses: 200,
            revelationType: RevelationType.MECCAN,
          );

          final store = Store<AppState>(
            appStateReducer,
            initialState: AppState(
              reader: ReaderScreenState(
                surahTitles: [surahTitle],
                currentIndex: const SurahIndex(
                  0,
                  1,
                ),
              ),
            ),
          );

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              0,
              999999,
            ),));

          expect(
            store.state.reader.currentIndex.aya,
            1,
          );
        },
      );

    },
  );
}
