import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/presentation/home/widgets/translation_display_widget.dart';
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

  group('TranslationDisplay', () {
    setUp(() async {});

    testGoldens('Display TranslationDisplay correctly',
        (WidgetTester tester) async {
      const widget = Center(
          child: TranslationDisplay(
              translationType: QTranslation.wahiduddinKhan,
              translation:
                  'God sends down water from the sky and with it revives the earth when it is dead. There is truly a sign in this for people who listen'));

      final builder = GoldenBuilder.column()
        ..addScenario('Default font size', widget)
        ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
        ..addTextScaleScenario('Largest font', widget, textScaleFactor: 3.2);
      await tester.pumpWidgetBuilder(builder.build(),
          surfaceSize: const Size(450, 1040));
      await screenMatchesGolden(tester, 'snapshot-translation-display');
    });
  });
}
