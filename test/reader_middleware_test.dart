import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/reader_screen_state.dart';
import 'package:redux/redux.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group(
    'InitializeReaderScreenAction',
    () {
      test(
        'Init returns same state',
        () async {
          final store = MockStore();

          store.dispatch(InitializeReaderScreenAction());

          expect(
            store.dispatchedActions,
            [InitializeReaderScreenAction()],
          );
        },
      );
    },
  );
}

// Store<AppState> _mockStore({
//   int sura = 0,
//   int aya = 1,
// }) {
//   NQSurahTitle surahTitle = NQSurahTitle(
//     number: 0,
//     name: "hashir1",
//     translationEn: "Test1",
//     transliterationEn: "Test1",
//     totalVerses: 200,
//     revelationType: RevelationType.MECCAN,
//   );
//
//   return MockStore();
// }

class MockStore implements Store<AppState> {
  List<dynamic> dispatchedActions = List<dynamic>.empty();

  @override
  Reducer<AppState> reducer = appStateReducer;

  @override
  void dispatch(dynamic action) {
    dispatchedActions.add(action);
  }

  final StreamController<AppState> _controller = StreamController.broadcast();

  @override
  Stream<AppState> get onChange => _controller.stream;

  @override
  AppState get state => const AppState(
        reader: ReaderScreenState(
          surahTitles: [],
          bookmarkState: SurahIndex(
            1,
            1,
          ),
          currentIndex: SurahIndex.defaultIndex,
        ),
      );

  @override
  Future<bool> teardown() {
    return Future<bool>.value(true);
  }
}
