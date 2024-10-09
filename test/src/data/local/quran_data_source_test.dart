import 'package:ayat_app/src/data/local/quran_local_data_source.dart';
import 'package:ayat_app/src/data/models/local/local_sura_title.dart';
import 'package:ayat_app/src/data/models/local/quran_local_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_quran/noble_quran.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Quran Local DataSource', () {
    test('Should be able to retrieve quran data', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();
      const index = 0;
      // Act
      QuranLocalData response = await sut.getPageQuranData(
        pageNo: index,
        translationType: NQTranslation.wahiduddinkhan,
      );
      // Assert
      expect(response.words.isNotEmpty, true);
      expect(response.translations.isNotEmpty, true);
      expect(response.transliterations.isNotEmpty, true);
      expect(response.translations[0].index, "1");
      expect(response.transliterations[0].index, "1");
      expect(response.words[0][0].sura, 1);
    });

    test('Should retrieve first sura data correctly', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();
      const index = 0;
      // Act
      QuranLocalData response = await sut.getPageQuranData(
        pageNo: index,
        translationType: NQTranslation.wahiduddinkhan,
      );
      // Assert
      expect(response.page.pgNo, 0);
      expect(response.translations[0].index, "1");
      expect(response.translations.length, 7);
      expect(response.translations[0].index, "1");
      expect(response.translations[0].text,
          "In the name of God, the Most Gracious, the Most Merciful");
      expect(response.translations[6].index, "7");
      expect(response.translations[6].text,
          "the path of those You have blessed; not of those who have incurred Your wrath, nor of those who have gone astray");

      expect(response.transliterations[0].index, "1");
      expect(response.transliterations.length, 7);
      expect(response.transliterations[0].index, "1");
      expect(response.transliterations[0].text,
          "Bismi All<u>a</U>hi a<b>l</B>rra<u>h</U>m<u>a</U>ni a<b>l</B>rra<u>h</U>eem<b>i</b>");
      expect(response.transliterations[6].index, "7");
      expect(response.transliterations[6].text,
          "<u>S</U>ir<u>at</U>a alla<u>th</U>eena anAAamta AAalayhim ghayri almagh<u>d</U>oobi AAalayhim wal<u>a</U> a<b>l</B><u>dda</U>lleen<b>a</b>");

      expect(response.words.length, 7);

      expect(response.words[0].length, 4);
      expect(response.words[0][0].sura, 1);
      expect(response.words[0][0].aya, 1);
      expect(response.words[0][0].ar, 'بِسْمِ');
      expect(response.words[0][0].tr, "In (the) name");

      expect(response.words[0].length, 4);
      expect(response.words[0][3].sura, 1);
      expect(response.words[0][3].aya, 1);
      expect(response.words[0][3].ar, 'الرَّحِيمِ');
      expect(response.words[0][3].tr, 'the Most Merciful.');

      expect(response.words[6].length, 9);
      expect(response.words[6][0].sura, 1);
      expect(response.words[6][0].aya, 7);
      expect(response.words[6][0].ar, 'صِرٰطَ');
      expect(response.words[6][0].tr, '(The) path');

      expect(response.words[6].length, 9);
      expect(response.words[6][8].sura, 1);
      expect(response.words[6][8].aya, 7);
      expect(response.words[6][8].ar, 'الضَّآلِّينَ');
      expect(response.words[6][8].tr, '(of) those who go astray.');
    });

    test('Should retrieve last sura data correctly', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();
      const index = 555;
      // Act
      QuranLocalData response = await sut.getPageQuranData(
        pageNo: index,
        translationType: NQTranslation.wahiduddinkhan,
      );
      // Assert
      expect(response.page.pgNo, 555);
      expect(response.page.firstAyaIndex.sura, 113);
      expect(response.translations.length, 6);
      expect(response.translations[0].index, "1");
      expect(response.translations[0].text,
          'Say, "I seek refuge in the Lord of people');
      expect(response.translations[5].index, "6");
      expect(response.translations[5].text, 'from jinn and men');

      expect(response.transliterations.length, 6);
      expect(response.transliterations[0].index, "1");
      expect(response.transliterations[0].text,
          'Qul aAAoo<u>th</U>u birabbi a<b>l</B>nn<u>a</U>s<b>i</b>');
      expect(response.transliterations[5].index, "6");
      expect(response.transliterations[5].text,
          'Mina aljinnati wa<b> al</B>nn<u>a</U>s<b>m</b>');

      expect(response.words.length, 6);

      expect(response.words[0].length, 4);
      expect(response.words[0][0].sura, 114);
      expect(response.words[0][0].aya, 1);
      expect(response.words[0][0].ar, 'قُلْ');
      expect(response.words[0][0].tr, 'Say,');

      expect(response.words[0].length, 4);
      expect(response.words[0][3].sura, 114);
      expect(response.words[0][3].aya, 1);
      expect(response.words[0][3].ar, 'النَّاسِ');
      expect(response.words[0][3].tr, '(of) mankind,');

      expect(response.words[5].length, 3);
      expect(response.words[5][0].sura, 114);
      expect(response.words[5][0].aya, 6);
      expect(response.words[5][0].ar, 'مِنَ');
      expect(response.words[5][0].tr, 'From');

      expect(response.words[5].length, 3);
      expect(response.words[5][2].sura, 114);
      expect(response.words[5][2].aya, 6);
      expect(response.words[5][2].ar, 'وَالنَّاسِ');
      expect(response.words[5][2].tr, 'and men.');
    });

    test('Should returns default value for invalid index', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();
      const index = 2000;

      // Act
      QuranLocalData response = await sut.getPageQuranData(
        pageNo: index,
        translationType: NQTranslation.wahiduddinkhan,
      );

      // Assert
      expect(response, QuranLocalData.defaultValue);
    });

    test('Should throw exception for negative index', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();
      const index = -200;

      // Act
      QuranLocalData response = await sut.getPageQuranData(
        pageNo: index,
        translationType: NQTranslation.wahiduddinkhan,
      );

      // Assert
      expect(response, QuranLocalData.defaultValue);
    });

    test('Should be able to retrieve sura titles', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();

      // Act
      final response = await sut.getSuraTitles();

      // Assert
      expect(response.isNotEmpty, true);
      expect(response.length, 114);
      expect(response.first, const LocalSuraTitle.defaultValue());
      expect(
          response.last,
          const LocalSuraTitle(
            number: 114,
            name: 'سورة الناس',
            transliterationEn: "An-Naas",
            translationEn: "Mankind",
            totalVerses: 6,
          ));
    });

    test('Should be able to retrieve first ruku', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();

      // Act
      final response = sut.getRuku(0, 0);

      // Assert
      expect(response?.id, 0);
      expect(response?.startIndexSura, 0);
      expect(response?.startIndexAya, 0);
      expect(response?.numOfAyas, 7);
    });

    test('Should be able to retrieve last ruku', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();

      // Act
      final response = sut.getRuku(113, 0);

      // Assert
      expect(response?.id, 555);
      expect(response?.startIndexSura, 113);
      expect(response?.startIndexAya, 0);
      expect(response?.numOfAyas, 6);
    });

    test('Should return null for invalid sura indices', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();

      // Act
      final response = sut.getRuku(1113, 0);

      // Assert
      expect(response, null);
    });

    test('Should return null for invalid aya indices', () async {
      // Arrange
      QuranDataSource sut = QuranLocalDataSourceImpl();

      // Act
      final response = sut.getRuku(0, 100);

      // Assert
      expect(response, null);
    });
  });
}
