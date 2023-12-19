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
          final store = _mockStore();

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
          final store = _mockStore();

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
          final store = _mockStore();

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
          final store = _mockStore(
            sura: 1,
            aya: 2,
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
          final store = _mockStore();

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
          final store = _mockStore();

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

      test(
        'Set select surah action sets index to the last surah updates state',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectSurahAction(
            index: const SurahIndex(
              113,
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
            const SurahIndex(
              113,
              1,
            ),
          );
        },
      );

      test(
        'Set select surah action sets index to one more than sura counts defaults',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectSurahAction(
            index: const SurahIndex(
              114,
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
          final store = _mockStore();

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
          final store = _mockStore();

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
          final store = _mockStore();

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

      test(
        'Select last aya action updates state',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectAyaAction(
            aya: 199,
          ));

          expect(
            store.state.reader.currentIndex,
            const SurahIndex(
              0,
              199,
            ),
          );
        },
      );

      test(
        'Select one more than last aya action doesnt updates state',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectAyaAction(
            aya: 200,
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
          final store = _mockStore();

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              1,
              1,
            ),
          ));

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
        'Select Particular aya action with invalid surah index sets default sura index',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              999,
              1,
            ),
          ));

          expect(
            store.state.reader.currentIndex,
            SurahIndex.defaultIndex,
          );
        },
      );

      test(
        'Select Particular aya action with surah index as last sura updates index',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              1,
              1,
            ),
          ));

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
        'Select Particular aya action with invalid aya index doesnt change aya index',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              0,
              999999,
            ),
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
        'Select Particular aya action with aya index as last aya updates current index',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              0,
              199,
            ),
          ));

          expect(
            store.state.reader.currentIndex,
            const SurahIndex(
              0,
              199,
            ),
          );
        },
      );

      test(
        'Select Particular aya action with aya index as one more than last aya doesnt updates current index',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              0,
              200,
            ),
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
        'Select Particular aya action with invalid sura and invalid aya defaults',
        () async {
          final store = _mockStore();

          await store.dispatch(SelectParticularAyaAction(
            index: const SurahIndex(
              999,
              999,
            ),
          ));

          expect(
            store.state.reader.currentIndex,
            SurahIndex.defaultIndex,
          );
        },
      );
    },
  );

  group(
    'ShowLoadingAction',
    () {
      test(
        'Show loading action sets isLoading state',
        () async {
          final store = _mockStore();

          await store.dispatch(ShowLoadingAction());

          expect(
            store.state.reader.isLoading,
            true,
          );
        },
      );
    },
  );

  group(
    'HideLoadingAction',
    () {
      test(
        'Hide loading action resets isLoading state',
        () async {
          final store = _mockStore();

          await store.dispatch(HideLoadingAction());

          expect(
            store.state.reader.isLoading,
            false,
          );
        },
      );
    },
  );

  group(
    'NextAyaAction',
    () {
      test(
        'Get next aya',
        () async {
          final store = _mockStore();

          await store.dispatch(NextAyaAction());

          expect(
            store.state.reader.currentIndex,
            const SurahIndex(
              0,
              2,
            ),
          );
        },
      );
      test(
        'Returns same index if at end of sura',
        () async {
          final store = _mockStore(
            sura: 0,
            aya: 199,
          );

          await store.dispatch(NextAyaAction());

          expect(
            store.state.reader.currentIndex,
            store.state.reader.currentIndex,
          );
        },
      );
    },
  );
}

Store<AppState> _mockStore({
  int sura = 0,
  int aya = 1,
}) {
  NQSurahTitle surahTitle = NQSurahTitle(
    number: 0,
    name: "hashir1",
    translationEn: "Test1",
    transliterationEn: "Test1",
    totalVerses: 200,
    revelationType: RevelationType.MECCAN,
  );

  return Store<AppState>(
    appStateReducer,
    initialState: AppState(
      reader: ReaderScreenState(
        surahTitles: [
          surahTitle,
          surahTitle,
        ],
        bookmarkState: const SurahIndex(
          1,
          1,
        ),
        currentIndex: SurahIndex(
          sura,
          aya,
        ),
      ),
    ),
  );
}
