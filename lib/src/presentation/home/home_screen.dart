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
      child: const _Content(),
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    if (bloc.state is! HomeLoadedState) {
      return const LoadingWidget();
    }

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
                    selectableAya:
                        bloc.currentPageData$.value.selectedIndex?.aya ??
                            bloc.currentPageData$.value.page.firstAyaIndex.aya,
                    pageData: data,
                    textScaleFactor: scale,
                    onNext: () => bloc.add(HomeNextPageEvent())),
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
