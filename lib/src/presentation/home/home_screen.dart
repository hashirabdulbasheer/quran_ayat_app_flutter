import 'package:ayat_app/src/presentation/widgets/error_widget.dart';

import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      child: const Column(
        children: [
          _Header(),
          Expanded(child: _Content()),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return StreamBuilder<QPageData>(
        stream: bloc.currentPageData$,
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return const SizedBox.shrink();
          }

          HomeLoadedState loadedState = bloc.state as HomeLoadedState;
          if (loadedState.suraTitles?.isEmpty == true) {
            return const CircularProgressIndicator();
          }

          return Column(
            children: [
              PageHeader(
                readingProgress: bloc.getReadingProgress(loadedState),
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
                    'aya': "${snapshot.data?.page.firstAyaIndex.human.aya ?? 1}"
                  },
                ),
                onTextSizeIncreasePressed: () => bloc
                    .add(TextSizeControlEvent(type: TextSizeControl.increase)),
                onTextSizeDecreasePressed: () => bloc
                    .add(TextSizeControlEvent(type: TextSizeControl.decrease)),
                onTextSizeResetPressed: () =>
                    bloc.add(TextSizeControlEvent(type: TextSizeControl.reset)),
                onPreviousPagePressed: () => bloc.add(HomePreviousPageEvent()),
              ),
            ],
          );
        });
  }
}

class _Content extends StatelessWidget {
  const _Content();

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
                  onNext: () => bloc.add(HomeNextPageEvent()),
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
