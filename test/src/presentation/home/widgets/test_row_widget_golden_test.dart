import 'package:ayat_app/src/presentation/home/widgets/text_row_widget.dart';
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

  group('TextRow', () {
    setUp(() async {});

    testGoldens('Display TextRow correctly', (WidgetTester tester) async {
      const widget = Center(
          child: TextRow(
              text:
                  'God sends down water from the sky and with it revives the earth when it is dead. There is truly a sign in this for people who listen'));
      final builder = GoldenBuilder.column()
        ..addScenario('Default font size', widget)
        ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
        ..addTextScaleScenario('Largest font', widget, textScaleFactor: 3.2);
      await tester.pumpWidgetBuilder(builder.build(),
          surfaceSize: const Size(450, 900));
      await screenMatchesGolden(tester, 'snapshot-text-row');
    });
  });
}
