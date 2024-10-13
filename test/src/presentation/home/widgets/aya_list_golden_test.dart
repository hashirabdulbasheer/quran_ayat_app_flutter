import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/models/page.dart';
import 'package:ayat_app/src/domain/models/qaya.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/presentation/home/widgets/aya_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hrk_flutter_test_batteries/hrk_flutter_test_batteries.dart';

///
/// flutter test --update-goldens
///
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await loadAppFonts();
    useGoldenFileComparatorWithThreshold(0.95); // 95.00%
  });

  group('Word by Word Aya List', () {
    setUp(() async {});

    testGoldens('Display WordByWordAyaList correctly',
        (WidgetTester tester) async {
      const words = [
        [
          QWord(word: 1, tr: "tr1", aya: 1, sura: 1, ar: 'الرحمان'),
          QWord(word: 2, tr: "tr2", aya: 1, sura: 1, ar: 'الرحمان'),
        ],
        [
          QWord(word: 1, tr: "tr1", aya: 2, sura: 1, ar: 'الرحمان'),
          QWord(word: 2, tr: "tr2", aya: 2, sura: 1, ar: 'الرحمان'),
        ],
      ];
      const translations = [
        (QTranslation.wahiduddinKhan, <QAya>[]),
        (QTranslation.wahiduddinKhan, <QAya>[])
      ];
      var widget = Center(
          child: SizedBox(
        height: 300,
        child: AyaList(
          pageData: QPageData(
              ayaWords: words,
              transliterations: const [],
              translations: translations,
              page: QPage(
                number: 0,
                firstAyaIndex: SurahIndex.defaultIndex,
                numberOfAya: 1,
              )),
          selectableAya: 0,
          onNext: () {},
          onBack: () {},
        ),
      ));
      final builder = GoldenBuilder.column()
        ..addScenario('Default font size', widget)
        ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
        ..addTextScaleScenario('Largest font', widget, textScaleFactor: 3.2);
      await tester.pumpWidgetBuilder(builder.build(),
          surfaceSize: const Size(1000, 2020));
      await screenMatchesGolden(tester, 'snapshot-aya-list');
    });
  });
}
