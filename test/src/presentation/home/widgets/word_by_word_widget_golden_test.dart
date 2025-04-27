import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:ayat_app/src/presentation/home/widgets/word_by_word_widget.dart';
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

  group('Word by Word', () {
    setUp(() async {});

    testGoldens('Display WordByWord correctly', (WidgetTester tester) async {
      const widget = Center(
          child: WordByWord(
        isWordByWordTranslationEnabled: true,
        word: QWord(
            word: 1, tr: "The Most Merciful", aya: 1, sura: 1, ar: "الرحمان"),
      ));
      final builder = GoldenBuilder.column()
        ..addScenario('Default font size', widget)
        ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
        ..addTextScaleScenario('Largest font', widget, textScaleFactor: 3.2);
      await tester.pumpWidgetBuilder(builder.build(),
          surfaceSize: const Size(430, 600));
      await screenMatchesGolden(tester, 'snapshot-word-by-word');
    });
  });
}
