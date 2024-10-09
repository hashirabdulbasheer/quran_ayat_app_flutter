import 'package:ayat_app/src/core/constants/app_constants.dart';
import 'package:ayat_app/src/domain/enums/text_size_control_type_enum.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/presentation/home/widgets/aya_list.dart';
import 'package:ayat_app/src/presentation/home/widgets/aya_navigation_control_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/controls_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/home_loading_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/page_header_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/text_scale_widget.dart';
import 'package:ayat_app/src/presentation/widgets/base_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/home_bloc.dart';

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
    if (bloc.state is! HomeLoadedState) {
      return const Center(child: CircularProgressIndicator());
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
        const SizedBox(
          width: 30,
        )
      ],
      bottomSheet: AyaNavigationControl(
        onNext: () => bloc.add(HomeNextPageEvent()),
        onPrevious: () => bloc.add(HomePreviousPageEvent()),
      ),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            _Header(),
            _Content(),
          ],
        ),
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
                ),
              ),
            ],
          );
        });
  }
}
