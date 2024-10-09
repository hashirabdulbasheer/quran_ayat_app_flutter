import 'package:ayat_app/src/domain/mappers/nqsurah_to_qsura_mapper.dart';
import 'package:ayat_app/src/domain/models/qaya.dart';
import 'package:ayat_app/src/domain/models/qsura.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/noble_quran.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('NQSurahToQSuraMapper', () {
    test('Should map nqSurah to qsura', () async {
      // Arrange
      NQSurahToQSuraMapper sut = NQSurahToQSuraMapper();

      // Act
      QSura response = sut.mapFrom(NQSurah(
        aya: [NQAyat(index: "1", text: "text")],
        index: '1',
        name: 'name',
      ));

      // Assert
      expect(response.aya.isNotEmpty, true);
      expect(response.aya.length, 1);
      expect(response.aya.first.index, "1");
      expect(response.aya.first.text, "text");
      expect(response.index, "1");
      expect(response.name, "name");
      expect(response, const QSura(
        aya: [QAya(index: "1", text: "text")],
        index: '1',
        name: 'name',
      ));
    });
  });
}
