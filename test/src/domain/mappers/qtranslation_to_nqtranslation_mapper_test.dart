
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/mappers/qtranslation_to_nqtranslation_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/noble_quran.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('QTranslationToNQTranslationMapper', () {
    test('Should map qTranslation to nqTranslation', () async {
      // Arrange
      QTranslationToNQTranslationMapper sut =
      QTranslationToNQTranslationMapper();

      // Act
      final response = sut.mapFrom(QTranslation.haleem);

      // Assert
      expect(response, NQTranslation.haleem);
    });
  });
}
