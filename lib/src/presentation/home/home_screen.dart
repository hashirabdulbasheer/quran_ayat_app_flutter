import 'package:ayat_app/src/core/constants/route_constants.dart';
import 'package:ayat_app/src/presentation/widgets/error_widget.dart';

import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _headerExpansionController = ExpansionTileController();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      ServicesBinding.instance.keyboard.addHandler(_onKey);
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      ServicesBinding.instance.keyboard.removeHandler(_onKey);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    if (bloc.state is HomeErrorState) {
      HomeErrorState errorState = bloc.state as HomeErrorState;
      return _ErrorScreen(message: errorState.message);
    } else if (bloc.state is! HomeLoadedState) {
      return const LoadingWidget();
    }

    if (bloc.currentPageData$.hasValue &&
        bloc.currentPageData$.value.ayaWords.isEmpty) {
      return const _ErrorScreen(message: null);
    }

    return QBaseScreen(
      title: "Noble Quran",
      navBarActions: [
        TextButton(
            onPressed: () async {
              if (!await launchUrl(Uri.parse(kBlogUrl))) {
                throw Exception('Could not launch $kBlogUrl');
              }
            },
            child: const Text("Blog",
                style: TextStyle(fontWeight: FontWeight.bold))),
        IconButton(
            tooltip: "Go to bookmark",
            onPressed: () => bloc.add(GoToBookmarkEvent()),
            icon: Icon(
              Icons.bookmark_border,
              color: Theme.of(context).primaryColor,
            )),
        const ThemeModeButton(),
        IconButton(
            tooltip: "About us",
            onPressed: () => context.goNamed(AppRoutes.about.name),
            icon: Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
            )),
        const SizedBox(width: 30)
      ],
      child: Column(
        children: [
          // expansion title for selecting sura/aya
          _Header(expansionController: _headerExpansionController),
          // reading progress
          const _ReadingProgressIndicator(),
          // space
          const SizedBox(height: 10),
          // the quran
          Expanded(child: _Content(
            onNavigationTapped: () {
              _headerExpansionController.collapse();
            },
          )),
        ],
      ),
    );
  }

  // Handle hardware keyboard events, for web only, to use hardware keyboard
  // to move between ayats on a desktop
  bool _onKey(KeyEvent event) {
    if (ModalRoute.of(context)?.isCurrent == false) {
      // do not handle key press if not this screen
      return false;
    }
    // right arrow key - back
    // left arrow key - next
    // space bar key - next
    // others ignore
    final key = event.logicalKey;
    final bloc = context.read<HomeBloc>();
    if (event is KeyDownEvent) {
      if (key == LogicalKeyboardKey.arrowRight) {
        bloc.add(HomePreviousPageEvent());
      } else if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.space) {
        bloc.add(HomeNextPageEvent());
      } else if (key == LogicalKeyboardKey.audioVolumeUp) {
        bloc.add(HomePreviousPageEvent());
      } else if (key == LogicalKeyboardKey.audioVolumeDown) {
        bloc.add(HomeNextPageEvent());
      } else if (key == LogicalKeyboardKey.mediaTrackPrevious) {
        bloc.add(HomePreviousPageEvent());
      } else if (key == LogicalKeyboardKey.mediaTrackNext) {
        bloc.add(HomeNextPageEvent());
      } else if ((HardwareKeyboard.instance.isControlPressed ||
              HardwareKeyboard.instance.isMetaPressed) &&
          key == LogicalKeyboardKey.keyB) {}
    }

    return false;
  }
}

class _ReadingProgressIndicator extends StatelessWidget {
  const _ReadingProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return StreamBuilder<QPageData>(
        stream: bloc.currentPageData$,
        builder: (context, snapshot) {
          QPageData? data = snapshot.data;
          if (snapshot.hasError || data == null) {
            return const SizedBox.shrink();
          }

          HomeLoadedState loadedState = bloc.state as HomeLoadedState;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: ReadingProgressIndicator(
                progress: bloc.getReadingProgress(loadedState)),
          );
        });
  }
}

class _Header extends StatelessWidget {
  final ExpansionTileController expansionController;

  const _Header({required this.expansionController});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return StreamBuilder<QPageData>(
        stream: bloc.currentPageData$,
        builder: (context, snapshot) {
          QPageData? data = snapshot.data;
          if (snapshot.hasError || data == null) {
            return const SizedBox.shrink();
          }

          HomeLoadedState loadedState = bloc.state as HomeLoadedState;
          if (loadedState.suraTitles?.isEmpty == true) {
            return const CircularProgressIndicator();
          }

          return ExpansionTile(
            dense: true,
            minTileHeight: 45,
            controller: expansionController,
            initiallyExpanded: false,
            maintainState: false,
            tilePadding: const EdgeInsets.symmetric(horizontal: 6),
            title: Text(_getTitle(data, loadedState),
                style: const TextStyle(fontSize: 12)),
            children: [
              PageHeader(
                surahTitles: loadedState.suraTitles ?? [],
                onSelection: (index) =>
                    bloc.add(HomeSelectSuraAyaEvent(index: index)),
                currentIndex: snapshot.data?.page.firstAyaIndex ??
                    SurahIndex.defaultIndex,
              ),
              DisplayControls(
                  onContextPressed: () => context.pushNamed(
                        "context",
                        pathParameters: {
                          'sura':
                              "${snapshot.data?.page.firstAyaIndex.human.sura ?? 1}",
                          'aya':
                              "${snapshot.data?.page.firstAyaIndex.human.aya ?? 1}"
                        },
                      ),
                  onTextSizeIncreasePressed: () => bloc.add(
                      TextSizeControlEvent(type: TextSizeControl.increase)),
                  onTextSizeDecreasePressed: () => bloc.add(
                      TextSizeControlEvent(type: TextSizeControl.decrease)),
                  onTextSizeResetPressed: () => bloc
                      .add(TextSizeControlEvent(type: TextSizeControl.reset))),
            ],
          );
        });
  }

  String _getTitle(QPageData data, HomeLoadedState loadedState) {
    int currentSura = data.page.firstAyaIndex.sura;
    SuraTitle suraTitle =
        loadedState.suraTitles?[currentSura] ?? const SuraTitle.defaultValue();
    return "${suraTitle.transliterationEn} / ${suraTitle.translationEn}";
  }
}

class _Content extends StatelessWidget {
  final VoidCallback onNavigationTapped;

  const _Content({required this.onNavigationTapped});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    if (bloc.state is! HomeLoadedState) {
      return const LoadingWidget();
    }
    HomeLoadedState loadedState = bloc.state as HomeLoadedState;

    return StreamBuilder<QPageData?>(
        stream: bloc.currentPageData$,
        builder: (context, snapshot) {
          QPageData? data = snapshot.data;
          if (data == null) return const LoadingWidget();

          return Column(
            children: [
              TextSizeAdjuster(
                settings$: bloc.settings$,
                child: (context, scale) => AyaList(
                  bookmarkIndex: loadedState.bookmarkIndex,
                  selectableAya:
                      bloc.currentPageData$.value.selectedIndex?.aya ??
                          bloc.currentPageData$.value.page.firstAyaIndex.aya,
                  pageData: data,
                  textScaleFactor: scale,
                  onNext: () {
                    onNavigationTapped();
                    bloc.add(HomeNextPageEvent());
                  },
                  onBack: () {
                    onNavigationTapped();
                    bloc.add(HomePreviousPageEvent());
                  },
                ),
              ),
            ],
          );
        });
  }
}

class _ErrorScreen extends StatelessWidget {
  final String? message;

  const _ErrorScreen({this.message});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();

    return QBaseScreen(
      title: "Noble Quran",
      navBarActions: [
        TextButton(
            onPressed: () async {
              if (!await launchUrl(Uri.parse(kBlogUrl))) {
                throw Exception('Could not launch $kBlogUrl');
              }
            },
            child: const Text("Blog",
                style: TextStyle(fontWeight: FontWeight.bold))),
        TextButton(
            onPressed: () {
              bloc.add(GoToBookmarkEvent());
            },
            child: const Text("Bookmark",
                style: TextStyle(fontWeight: FontWeight.bold))),
        const ThemeModeButton(),
        const SizedBox(
          width: 30,
        )
      ],
      child: Center(
        child: QErrorWidget(
          message: message ?? "Some error occurred. Please retry.",
          onRetry: () => context.replace(Uri.base.path),
        ),
      ),
    );
  }
}
