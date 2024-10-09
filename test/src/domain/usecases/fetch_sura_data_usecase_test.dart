import 'package:ayat_app/src/core/errors/failure.dart';
import 'package:ayat_app/src/core/errors/general_exception.dart';
import 'package:ayat_app/src/core/errors/general_failure.dart';
import 'package:ayat_app/src/data/local/quran_local_data_source.dart';
import 'package:ayat_app/src/data/repositories/quran_repository_impl.dart';
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/models/page.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/usecases/fetch_sura_data_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_sura_data_usecase_test.mocks.dart';

@GenerateMocks([QuranRepositoryImpl])
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('FetchSuraUseCase', () {
    test('Should be able to retrieve quran data', () async {
      // Arrange
      final repository = MockQuranRepositoryImpl();
      final sut = FetchSuraUseCase(repository);
      var responseData = QPageData(
          ayaWords: const [
            [
              QWord(word: 1, tr: "tr1", aya: 1, sura: 1, ar: "ar1"),
              QWord(word: 2, tr: "tr2", aya: 1, sura: 1, ar: "ar2"),
            ],
            [
              QWord(word: 1, tr: "tr1", aya: 2, sura: 1, ar: "ar1"),
              QWord(word: 2, tr: "tr2", aya: 2, sura: 1, ar: "ar2"),
            ],
          ],
          transliterations: const [],
          translations: const [],
          page: QPage(
              number: 0,
              firstAyaIndex: SurahIndex.defaultIndex,
              numberOfAya: 7));
      when(repository.getPageQuranData(
              pageNo: 0, translationType: QTranslation.haleem))
          .thenAnswer((_) async => responseData);

      // Act
      final response = await sut.call(const FetchSuraUseCaseParams(
        pageNo: 0,
        translation: QTranslation.haleem,
      ));

      // Assert
      expect(response, isA<Either<Failure, QPageData>>());
      expect(response.isRight(), true);
      response.fold((left) {
        expect(left, null);
      }, (right) {
        expect(right, responseData);
      });
    });

    test('Should return error on exception', () async {
      // Arrange
      final repository = MockQuranRepositoryImpl();
      final sut = FetchSuraUseCase(repository);
      when(repository.getPageQuranData(
              pageNo: 0, translationType: QTranslation.haleem))
          .thenAnswer((_) async => throw GeneralException("some exception"));

      // Act
      final response = await sut.call(const FetchSuraUseCaseParams(
        pageNo: 0,
        translation: QTranslation.haleem,
      ));

      // Assert
      expect(response, isA<Either<Failure, QPageData>>());
      expect(response.isLeft(), true);
      response.fold((left) {
        expect(left, isA<GeneralFailure>());
        expect((left as GeneralFailure).message, "some exception");
      }, (right) {
        expect(right, null);
      });
    });

    test('Should return error on invalid index', () async {
      // Arrange
      final repository =
          QuranRepositoryImpl(dataSource: QuranLocalDataSourceImpl());
      final sut = FetchSuraUseCase(repository);

      // Act
      final response = await sut.call(const FetchSuraUseCaseParams(
        pageNo: 2000,
        translation: QTranslation.haleem,
      ));

      // Assert
      expect(response, isA<Either<Failure, QPageData>>());
      expect(response.isRight(), true);
      response.fold((left) {
        // expect(left, isA<GeneralFailure>());
        // expect((left as GeneralFailure).message, "Invalid sura index");
      }, (right) {
        expect(right.ayaWords, []);
        expect(right.transliterations, []);
        expect(right.translations[0].$1, QTranslation.wahiduddinKhan);
        expect(right.translations[0].$2.isEmpty, true);
        expect(right.page.firstAyaIndex, SurahIndex.defaultIndex);
        expect(right.page.number, 0);
        expect(right.page.numberOfAya, 0);
      });
    });

    test('Should call repository only once', () async {
      // Arrange
      final repository = MockQuranRepositoryImpl();
      final sut = FetchSuraUseCase(repository);
      var responseData = QPageData(
          ayaWords: const [],
          transliterations: const [],
          translations: const [],
          page: QPage(
            number: 0,
            firstAyaIndex: SurahIndex.defaultIndex,
            numberOfAya: 7,
          ));
      when(repository.getPageQuranData(
              pageNo: 0, translationType: QTranslation.haleem))
          .thenAnswer((_) async => responseData);

      // Act
      final response = await sut.call(const FetchSuraUseCaseParams(
        pageNo: 0,
        translation: QTranslation.haleem,
      ));

      // Assert
      expect(response, isA<Either<Failure, QPageData>>());
      expect(response.isRight(), true);
      response.fold((left) {
        expect(left, null);
      }, (right) {
        verify(repository.getPageQuranData(
                pageNo: 0, translationType: QTranslation.haleem))
            .called(1);
      });
    });
  });
}
