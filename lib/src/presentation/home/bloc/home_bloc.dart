import 'package:ayat_app/src/presentation/home/home.dart';

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
    on<GoToFirstAyaEvent>(_onGotoFirstAya);

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

    // fetch settings
    settings$.add(fetchFontScaleUseCase.call());

    // auto bookmark loading
    SurahIndex? bookmarkIndex = fetchBookmarkUseCase.call();
    SurahIndex indexToLoad = event.index ?? bookmarkIndex;

    // fetch titles
    final suraTitlesResponse = await fetchSuraTitlesUseCase.call(NoParams());

    // fetch data
    await suraTitlesResponse.fold((left) async {
      emit(HomeErrorState(message: (left as GeneralFailure).message));
    }, (right) async {
      emit(HomeLoadedState(suraTitles: right, bookmarkIndex: bookmarkIndex));
      add(HomeFetchQuranDataEvent(pageNo: 0, selectedIndex: indexToLoad));
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
    emit((state as HomeLoadedState).copyWith(bookmarkIndex: event.index));
  }

  void _onGotoFirstAya(
    GoToFirstAyaEvent event,
    Emitter<HomeState> emit,
  ) {
    final currentPageData = currentPageData$.value;
    currentPageData$.add(currentPageData.copyWith(
      selectedIndex: currentPageData.page.firstAyaIndex,
    ));
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
