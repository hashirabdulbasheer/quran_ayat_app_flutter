import 'package:ayat_app/src/core/errors/general_exception.dart';
import 'package:ayat_app/src/data/local/quran_local_data_source.dart';
import 'package:ayat_app/src/data/models/local/quran_local_data.dart';
import 'package:ayat_app/src/data/models/local_page.dart';
import 'package:ayat_app/src/data/repositories/quran_repository_impl.dart';
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/repositories/quran_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:noble_quran/noble_quran.dart';

import 'quran_repository_impl_test.mocks.dart';

@GenerateMocks([QuranLocalDataSourceImpl])
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Quran Repository', () {
    test('Should be able to retrieve quran data', () async {
      // Arrange
      QuranRepository sut =
          QuranRepositoryImpl(dataSource: QuranLocalDataSourceImpl());
      const index = 0;

      // Act
      Exception? exception;
      QPageData? response;
      try {
        response = await sut.getPageQuranData(
          pageNo: index,
          translationType: QTranslation.wahiduddinKhan,
        );
      } catch (e) {
        exception = e as Exception;
      }

      // Assert
      expect(exception == null, true);
      expect(response != null, true);
      expect(response?.ayaWords.isNotEmpty, true);
      expect(response?.translations.isNotEmpty, true);
      expect(response?.transliterations.isNotEmpty, true);
      expect(response?.translations[0].$2[0].index, "1");
      expect(response?.transliterations[0].index, "1");
      expect(response?.ayaWords[0][0].sura, 1);
    });

    test('Should call data source only once', () async {
      // Arrange
      final dataSource = MockQuranLocalDataSourceImpl();
      QuranRepository sut = QuranRepositoryImpl(dataSource: dataSource);
      const index = 0;
      when(dataSource.getPageQuranData(
              pageNo: index, translationType: NQTranslation.wahiduddinkhan))
          .thenAnswer(
        (_) async => const QuranLocalData(
          page: LocalPage(
            pgNo: 0,
            firstAyaIndex: (sura: 0, aya: 0),
            numOfAya: 7,
          ),
          words: [],
          transliterations: [],
          translations: [],
        ),
      );

      // Act
      final _ = await sut.getPageQuranData(
        pageNo: index,
        translationType: QTranslation.wahiduddinKhan,
      );

      // Assert
      verify(dataSource.getPageQuranData(
              pageNo: index, translationType: NQTranslation.wahiduddinkhan))
          .called(1);
    });

    test('Should throw if datasource throws', () async {
      // Arrange
      final dataSource = MockQuranLocalDataSourceImpl();
      QuranRepository sut = QuranRepositoryImpl(dataSource: dataSource);
      const index = 0;
      when(dataSource.getPageQuranData(
              pageNo: index, translationType: NQTranslation.wahiduddinkhan))
          .thenAnswer(
        (_) async => throw (GeneralException("some exception")),
      );

      // Act
      Exception? exception;
      QPageData? response;
      try {
        response = await sut.getPageQuranData(
          pageNo: index,
          translationType: QTranslation.wahiduddinKhan,
        );
      } catch (e) {
        exception = e as Exception;
      }

      // Assert
      expect(exception != null, true);
      expect(response == null, true);
    });

    test('Should throw if datasource is requested with an invalid index',
        () async {
      // Arrange
      final dataSource = MockQuranLocalDataSourceImpl();
      QuranRepository sut = QuranRepositoryImpl(dataSource: dataSource);
      const index = 200;
      when(dataSource.getPageQuranData(
              pageNo: index, translationType: NQTranslation.wahiduddinkhan))
          .thenAnswer(
        (_) async => throw (GeneralException("some exception")),
      );

      // Act
      Exception? exception;
      QPageData? response;
      try {
        response = await sut.getPageQuranData(
          pageNo: index,
          translationType: QTranslation.wahiduddinKhan,
        );
      } catch (e) {
        exception = e as Exception;
      }

      // Assert
      expect(exception != null, true);
      expect(response == null, true);
    });

    test('Should throw if datasource is requested with an negative index',
        () async {
      // Arrange
      final dataSource = MockQuranLocalDataSourceImpl();
      QuranRepository sut = QuranRepositoryImpl(dataSource: dataSource);
      const index = -200;
      when(dataSource.getPageQuranData(
              pageNo: index, translationType: NQTranslation.wahiduddinkhan))
          .thenAnswer(
        (_) async => throw (GeneralException("some exception")),
      );

      // Act
      Exception? exception;
      QPageData? response;
      try {
        response = await sut.getPageQuranData(
          pageNo: index,
          translationType: QTranslation.wahiduddinKhan,
        );
      } catch (e) {
        exception = e as Exception;
      }

      // Assert
      expect(exception != null, true);
      expect(response == null, true);
    });

    test('Should be able to retrieve sura titles', () async {
      // Arrange
      QuranRepository sut =
          QuranRepositoryImpl(dataSource: QuranLocalDataSourceImpl());

      // Act
      Exception? exception;
      List<SuraTitle>? response;
      try {
        response = await sut.getSuraTitles();
      } catch (e) {
        exception = e as Exception;
      }

      // Assert
      expect(exception == null, true);
      expect(response != null, true);
      expect(response?.isNotEmpty, true);
      expect(response?.length, 114);
      expect(response?.first, const SuraTitle.defaultValue());
      expect(
          response?.last,
          const SuraTitle(
            number: 114,
            name: 'سورة الناس',
            transliterationEn: "An-Naas",
            translationEn: "Mankind",
            totalVerses: 6,
          ));
      expect(response?[18].number, 19);
    });

    test('Should throw if datasource get sura titles throws exception',
        () async {
      // Arrange
      final dataSource = MockQuranLocalDataSourceImpl();
      QuranRepository sut = QuranRepositoryImpl(dataSource: dataSource);
      when(dataSource.getSuraTitles()).thenAnswer(
        (_) async => throw (GeneralException("some exception")),
      );

      // Act
      Exception? exception;
      List<SuraTitle>? response;
      try {
        response = await sut.getSuraTitles();
      } catch (e) {
        exception = e as Exception;
      }

      // Assert
      expect(exception != null, true);
      expect(response == null, true);
    });

    test('Should be able to retrieve first ruku', () async {
      // Arrange
      final dataSource = MockQuranLocalDataSourceImpl();
      QuranRepository sut = QuranRepositoryImpl(dataSource: dataSource);
      when(dataSource.getRuku(0, 0)).thenAnswer(
        (_) => const NQRuku(
            id: 0, startIndexSura: 0, startIndexAya: 0, numOfAyas: 7),
      );

      // Act
      final response = sut.getRuku(SurahIndex.defaultIndex);

      // Assert
      expect(response?.id, 0);
      expect(response?.startIndex, const SurahIndex.fromHuman(sura: 1, aya: 1));
      expect(response?.numOfAya, 7);
    });
  });
}
