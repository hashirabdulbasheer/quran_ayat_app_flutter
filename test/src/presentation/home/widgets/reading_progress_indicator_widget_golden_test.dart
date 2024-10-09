import 'package:ayat_app/src/presentation/home/widgets/reading_progress_indicator_widget.dart';
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

  group('ReadingProgressWidget', () {
    setUp(() async {});

    testGoldens('reading progress indicator', (WidgetTester tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
            'First Aya', const ReadingProgressIndicator(progress: 0.0))
        ..addScenario(
            'Middle Aya', const ReadingProgressIndicator(progress: 0.5))
        ..addScenario(
            'Last Aya', const ReadingProgressIndicator(progress: 1.0));
      await tester.pumpWidgetBuilder(builder.build(),
          surfaceSize: const Size(230, 170));
      await screenMatchesGolden(tester, 'snapshot-reading-progress');
    });
  });
}
