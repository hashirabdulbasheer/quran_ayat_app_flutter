import 'package:ayat_app/src/domain/mappers/nqwordlistlist_to_qwordlistlist_mapper.dart';
import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/noble_quran.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('NQWordListListToQWordListListMapper', () {
    test('Should map List<List<NQWord>> to List<List<QWord>>', () async {
      // Arrange
      final from = [
        [
          NQWord(word: 1, tr: "tr1", aya: 1, sura: 1, ar: "ar1"),
          NQWord(word: 2, tr: "tr2", aya: 1, sura: 1, ar: "ar2"),
        ],
        [
          NQWord(word: 1, tr: "tr1", aya: 2, sura: 1, ar: "ar1"),
          NQWord(word: 2, tr: "tr2", aya: 2, sura: 1, ar: "ar2"),
        ],
      ];
      NQWordListListToQWordListListMapper sut =
          NQWordListListToQWordListListMapper();

      // Act
      final response = sut.mapFrom(from);

      // Assert
      expect(response, const [
        [
          QWord(word: 1, tr: "tr1", aya: 1, sura: 1, ar: "ar1"),
          QWord(word: 2, tr: "tr2", aya: 1, sura: 1, ar: "ar2"),
        ],
        [
          QWord(word: 1, tr: "tr1", aya: 2, sura: 1, ar: "ar1"),
          QWord(word: 2, tr: "tr2", aya: 2, sura: 1, ar: "ar2"),
        ],
      ]);
    });
  });
}
