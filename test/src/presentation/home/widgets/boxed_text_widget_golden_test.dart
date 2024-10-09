import 'package:ayat_app/src/presentation/home/widgets/boxed_text_widget.dart';
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

  group('BoxedText', () {
    setUp(() async {});

    testGoldens('Display ArabicText correctly', (WidgetTester tester) async {
      const widget = Center(child: BoxedText(text: 'The Most Merciful'));
      final builder = GoldenBuilder.column()
        ..addScenario('Default font size', widget)
        ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
        ..addTextScaleScenario('Largest font', widget, textScaleFactor: 3.2);
      await tester.pumpWidgetBuilder(builder.build(), surfaceSize: const Size(450, 320));
      await screenMatchesGolden(tester, 'snapshot-boxed-text');
    });
  });
}
