import 'package:ayat_app/src/core/errors/failure.dart';
import 'package:ayat_app/src/core/errors/general_exception.dart';
import 'package:ayat_app/src/core/errors/general_failure.dart';
import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/data/repositories/quran_repository_impl.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/usecases/fetch_sura_titles_usecase.dart';
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

  group('FetchSuraTitlesUseCase', () {
    test('Should be able to retrieve quran data', () async {
      // Arrange
      final repository = MockQuranRepositoryImpl();
      final sut = FetchSuraTitlesUseCase(repository);
      const responseData = [SuraTitle.defaultValue()];
      when(repository.getSuraTitles()).thenAnswer((_) async => responseData);

      // Act
      final response = await sut.call(NoParams());

      // Assert
      expect(response, isA<Either<Failure, List<SuraTitle>>>());
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
      final sut = FetchSuraTitlesUseCase(repository);
      when(repository.getSuraTitles())
          .thenAnswer((_) async => throw GeneralException("some exception"));

      // Act
      final response = await sut.call(NoParams());

      // Assert
      expect(response, isA<Either<Failure, List<SuraTitle>>>());
      expect(response.isLeft(), true);
      response.fold((left) {
        expect(left, isA<GeneralFailure>());
        expect((left as GeneralFailure).message, "some exception");
      }, (right) {
        expect(right, null);
      });
    });
  });
}
