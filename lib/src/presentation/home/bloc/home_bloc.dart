import 'package:ayat_app/src/core/errors/general_failure.dart';
import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/enums/text_size_control_type_enum.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/usecases/fetch_bookmark_usecase.dart';
import 'package:ayat_app/src/domain/usecases/fetch_font_scale_usecase.dart';
import 'package:ayat_app/src/domain/usecases/fetch_ruku_index_usecase.dart';
import 'package:ayat_app/src/domain/usecases/fetch_sura_data_usecase.dart';
import 'package:ayat_app/src/domain/usecases/fetch_sura_titles_usecase.dart';
import 'package:ayat_app/src/domain/usecases/save_bookmark_usecase.dart';
import 'package:ayat_app/src/domain/usecases/set_font_scale_usecase.dart';
import 'package:ayat_app/src/presentation/home/bloc/extensions/home_bloc_utils_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchFontScaleUseCase fetchFontScaleUseCase;
  final SetFontScaleUseCase setFontScaleUseCase;
  final FetchSuraTitlesUseCase fetchSuraTitlesUseCase;
  final FetchSuraUseCase fetchSuraUseCase;
  final FetchRukuIndexUseCase fetchRukuIndexUseCase;
  final FetchBookmarkUseCase fetchBookmarkUseCase;
  final SaveBookmarkUseCase saveBookmarkUseCase;

  final currentPageData$ = BehaviorSubject<QPageData>();
  final settings$ = BehaviorSubject<double>.seeded(1.0);

  HomeBloc({
    required this.fetchSuraTitlesUseCase,
    required this.fetchFontScaleUseCase,
    required this.setFontScaleUseCase,
    required this.fetchSuraUseCase,
    required this.fetchRukuIndexUseCase,
    required this.fetchBookmarkUseCase,
    required this.saveBookmarkUseCase,
  }) : super(HomeLoadedState()) {
    on<HomeInitializeEvent>(_onInitialize);
    on<HomeFetchQuranDataEvent>(_onFetchQuranData);
    on<HomeNextPageEvent>(_onNextPage);
    on<HomePreviousPageEvent>(_onPreviousPage);
    on<HomeSelectSuraAyaEvent>(_onSuraAyaSelected);
    on<TextSizeControlEvent>(_onTextSizeControl);
    on<GoToBookmarkEvent>(_onGoToBookmark);
    on<AddBookmarkEvent>(_onAddBookmark);

    _registerListeners();
  }

  @override
  Future<void> close() async {
    await _unregisterListeners();
    return super.close();
  }

  void _onInitialize(HomeInitializeEvent event, Emitter<HomeState> emit) async {
    // reset
    emit(HomeLoadedState(suraTitles: const []));

    // fetch titles
    final suraTitlesResponse = await fetchSuraTitlesUseCase.call(NoParams());

    // fetch settings
    settings$.add(fetchFontScaleUseCase.call());

    // fetch data
    await suraTitlesResponse.fold((left) async {
      emit(HomeErrorState(message: (left as GeneralFailure).message));
    }, (right) async {
      emit(HomeLoadedState(suraTitles: right));
      add(HomeFetchQuranDataEvent(
        pageNo: 0,
        selectedIndex: event.index,
      ));
    });
  }

  void _onFetchQuranData(
    HomeFetchQuranDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    // if there is a selected index then it will given preference over page no
    final selectedIndex = event.selectedIndex;
    int pageNo = selectedIndex != null
        ? fetchRukuIndexUseCase
                .call(FetchRukuIndexUseCaseParams(index: selectedIndex))
                ?.id ??
            event.pageNo
        : event.pageNo;
    final suraDataResponse = await fetchSuraUseCase.call(
      FetchSuraUseCaseParams(
        pageNo: pageNo,
        translation: QTranslation.wahiduddinKhan,
      ),
    );

    final bookmark = fetchBookmarkUseCase.call();

    await suraDataResponse.fold((left) async {
      emit(HomeErrorState(message: (left as GeneralFailure).message));
    }, (right) async {
      currentPageData$.add(right.copyWith(
        selectedIndex: event.selectedIndex,
        bookmarkIndex: bookmark,
      ));
    });
  }

  void _onNextPage(
    HomeNextPageEvent event,
    Emitter<HomeState> emit,
  ) async {
    QPageData pageData = currentPageData$.value;
    add(HomeFetchQuranDataEvent(pageNo: pageData.page.number + 1));
  }

  void _onPreviousPage(
    HomePreviousPageEvent event,
    Emitter<HomeState> emit,
  ) async {
    QPageData pageData = currentPageData$.value;
    final previousPage = pageData.page.number - 1;
    if (previousPage >= 0) {
      add(HomeFetchQuranDataEvent(pageNo: previousPage));
    }
  }

  void _onSuraAyaSelected(
    HomeSelectSuraAyaEvent event,
    Emitter<HomeState> emit,
  ) async {
    add(HomeFetchQuranDataEvent(pageNo: 0, selectedIndex: event.index));
  }

  void _onGoToBookmark(
    GoToBookmarkEvent event,
    Emitter<HomeState> emit,
  ) async {
    final bookmark = fetchBookmarkUseCase.call();
    add(HomeFetchQuranDataEvent(pageNo: 0, selectedIndex: bookmark));
  }

  void _onAddBookmark(
    AddBookmarkEvent event,
    Emitter<HomeState> emit,
  ) {
    saveBookmarkUseCase.call(event.index);
    add(HomeFetchQuranDataEvent(pageNo: 0, selectedIndex: event.index));
  }

  void _onTextSizeControl(
    TextSizeControlEvent event,
    Emitter<HomeState> emit,
  ) async {
    double newValue = settings$.value;
    switch (event.type) {
      case TextSizeControl.increase:
        newValue = await increaseTextSize();
      case TextSizeControl.decrease:
        newValue = await decreaseTextSize();
      case TextSizeControl.reset:
        newValue = await resetTextSize();
    }
    settings$.add(newValue);
  }

  void _registerListeners() {}

  Future _unregisterListeners() async {
    await currentPageData$.close();
    await settings$.close();
  }

  double getReadingProgress(HomeLoadedState state) {
    final page = currentPageData$.value.page;
    final lastAya = page.firstAyaIndex.aya + page.numberOfAya;
    final title = state.suraTitles?[page.firstAyaIndex.sura];

    return title == null ? 0.0 : lastAya / title.totalVerses;
  }
}
