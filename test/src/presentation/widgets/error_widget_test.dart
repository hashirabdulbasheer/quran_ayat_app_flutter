import 'package:ayat_app/src/presentation/widgets/error_widget.dart';
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

  group('Error Widget', () {
    setUp(() async {});

    testGoldens('Display ErrorWidget correctly', (WidgetTester tester) async {
      var widget =
          Center(child: QErrorWidget(message: "Some error", onRetry: () {}));
      await tester.pumpWidgetBuilder(widget, surfaceSize: const Size(100, 70));
      await screenMatchesGolden(tester, 'snapshot-error-widget');
    });
  });
}
