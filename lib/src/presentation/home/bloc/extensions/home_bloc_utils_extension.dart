import 'package:ayat_app/src/core/constants/app_constants.dart';
import 'package:ayat_app/src/domain/usecases/set_font_scale_usecase.dart';

import '../home_bloc.dart';

extension HomeBlocUtils on HomeBloc {
  /*
  ///
  ///  UTILS
  ///

  ///
  /// Return the indices of the starting aya and the ending aya of the current page
  ///
  ({int start, int end}) getCurrentPageAyaIndices({
    required HomeLoadedState state,
  }) {
    // current start index
    final currentIndex = currentPage$.value;

    final currentPage = getPageNumber(
      aya: currentIndex.startIndex.aya,
      numAyaPerPage: state.numberOfAyaPerPage,
    );

    final suraLength = state.quranData?.suraWords.length ?? 0;

    return getAyaIndicesForPage(
      page: currentPage,
      suraLength: suraLength,
      numAyaPerPage: state.numberOfAyaPerPage,
    );
  }

  ///
  /// Return the indices of the starting aya and the ending aya of a page
  ///
  ({int start, int end}) getAyaIndicesForPage({
    required int page,
    required int suraLength,
    required int numAyaPerPage,
  }) {
    if (suraLength <= 0) {
      return (start: 0, end: 0);
    }

    final startIndex = getFirstAyaOfPage(
      page: page,
      numAyaPerPage: numAyaPerPage,
    );

    final lastAyaOfPage = startIndex + numAyaPerPage - 1;

    final int endIndex = lastAyaOfPage.clamp(
      0,
      suraLength - 1,
    );

    return (start: startIndex, end: endIndex);
  }

  ///
  /// Return the sura details of a sura
  ///
  SuraTitle getSuraDetails({
    required HomeLoadedState state,
    required int sura,
  }) {
    final suraTitles = state.suraTitles;
    if (suraTitles == null || suraTitles.isEmpty) {
      // TODO: Think about return null instead
      return const SuraTitle.defaultValue();
    }

    return suraTitles[sura];
  }

  ///
  /// Returns the page number of an aya
  ///
  int getPageNumber({
    required int aya,
    required int numAyaPerPage,
  }) {
    return (aya / numAyaPerPage).floor();
  }

  ///
  /// Returns the first aya of a page
  ///
  int getFirstAyaOfPage({
    required int page,
    required int numAyaPerPage,
  }) {
    return page * numAyaPerPage;
  }

  int getFirstAyaOfCurrentPage({
    required int numAyaPerPage,
  }) {
    final currentIndex = currentPageData$.value?.page.startIndex;
    final page = getPageNumber(
      aya: currentIndex.startIndex.aya,
      numAyaPerPage: numAyaPerPage,
    );
    return page * numAyaPerPage;
  }

  double getCurrentReadingProgress() {
    if (state is! HomeLoadedState) return 0.0;

    final loadedState = state as HomeLoadedState;

    final currentIndex = currentPageData$.value.page.startIndex;

    final suraDetails = getSuraDetails(
      state: loadedState,
      sura: currentIndex.startIndex.sura,
    );

    final totalVerses = suraDetails.totalVerses - 1;
    if (totalVerses == 0) return 0.0;

    final progress = currentIndex.startIndex.aya / totalVerses;

    return progress;
  }

  bool isNextSura(HomeLoadedState state, QPage currentPage) {
    final suraDetails = getSuraDetails(
      state: state,
      sura: currentPage.startIndex.sura,
    );
    final currentPageNumber = getPageNumber(
      aya: currentPage.startIndex.aya,
      numAyaPerPage: state.numberOfAyaPerPage,
    );
    final nextPageFirstAyaIndex = getFirstAyaOfPage(
      page: currentPageNumber + 1,
      numAyaPerPage: state.numberOfAyaPerPage,
    );
    return nextPageFirstAyaIndex > suraDetails.totalVerses - 1;
  }

  void loadNextSura(QPage currentPage) {
    int nextSuraIndexInt = currentPage.startIndex.sura + 1;
    if (nextSuraIndexInt < 114) {
      final nextSuraIndex = SurahIndex(nextSuraIndexInt, 0);
      //TODO:
      // add(HomeFetchQuranDataEvent(index: nextSuraIndex));
    }
  }

  bool isPreviousSura(HomeLoadedState state, QPage currentPage) {
    final numberOfAyaPerPage = state.numberOfAyaPerPage;

    final currentPageNumber = getPageNumber(
      aya: currentPage.startIndex.aya,
      numAyaPerPage: numberOfAyaPerPage,
    );
    final previousPageFirstAyaIndex = getFirstAyaOfPage(
      page: currentPageNumber - 1,
      numAyaPerPage: numberOfAyaPerPage,
    );
    return previousPageFirstAyaIndex < 0;
  }

  void loadPreviousSura(HomeLoadedState state, SurahIndex currentIndex) {
    int previousSuraIndexInt = currentIndex.sura - 1;

    if (previousSuraIndexInt >= 0) {
      final previousSuraTotalVerse =
          state.suraTitles?[previousSuraIndexInt].totalVerses ?? 1;

      final previousSuraIndex = SurahIndex(
        previousSuraIndexInt,
        previousSuraTotalVerse - 1,
      );
      // TODO:
      // add(HomeFetchQuranDataEvent(index: previousSuraIndex));
    }
  }
 */
  Future<double> increaseTextSize() async {
    double currentScale = fetchFontScaleUseCase.call();
    if (currentScale < kFontScaleFactor * 10) {
      currentScale = currentScale + kFontScaleFactor;
    }
    await setFontScaleUseCase.call(SetFontScaleParams(fontScale: currentScale));
    return currentScale;
  }

  Future<double> decreaseTextSize() async {
    double currentScale = fetchFontScaleUseCase.call();
    if (currentScale > kFontScaleFactor * 2) {
      currentScale = currentScale - kFontScaleFactor;
    }
    await setFontScaleUseCase.call(SetFontScaleParams(fontScale: currentScale));
    return currentScale;
  }

  Future<double> resetTextSize() async {
    double currentScale = 1;
    await setFontScaleUseCase.call(SetFontScaleParams(fontScale: currentScale));
    return currentScale;
  }
}
