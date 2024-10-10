import 'package:ayat_app/src/presentation/home/home.dart';

class AyaList extends StatelessWidget {
  final int selectableAya;
  final QPageData pageData;
  final double textScaleFactor;
  final VoidCallback onNext;

  const AyaList({
    super.key,
    required this.pageData,
    required this.selectableAya,
    required this.onNext,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final ayaWords = pageData.ayaWords;
    final translations = pageData.translations[0];

    if (ayaWords.isEmpty || translations.$2.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstAyaIndex = pageData.page.firstAyaIndex;
    final bookmarkIndex = pageData.bookmarkIndex;

    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ScrollableListWidget(
            initialIndex: (selectableAya - (ayaWords[0][0].aya - 1)).abs(),
            itemsCount: pageData.page.numberOfAya + 1,
            itemContent: (index) {
              if (index == pageData.page.numberOfAya) {
                // we are at the last index, show controls
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: AyaNavigationControl(onNext: onNext),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: Column(
                  children: [
                    if (index == 0) ...[
                      // added header before one item
                      const _Header(),
                    ],

                    /// index
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// aya controls
                        AyaControlWidget(
                            onMore: () {
                              launchUrl(
                                  Uri.parse(
                                      "$kLegacyAppUrl/${firstAyaIndex.human.sura}/${_currentSuraIndex(index).human.aya}"),
                                  mode: LaunchMode.inAppBrowserView);
                            },
                            onBookmarked: () {
                              context.read<HomeBloc>().add(
                                    AddBookmarkEvent(
                                        index: _currentSuraIndex(index)),
                                  );
                              _showMessage(context, "Bookmark saved");
                            },
                            isBookmarked: _isBookmarked(
                                _currentSuraIndex(index), bookmarkIndex)),

                        /// index
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${firstAyaIndex.human.sura}:${firstAyaIndex.human.aya + index}",
                              style: const TextStyle(fontSize: 12),
                            )),
                      ],
                    ),

                    /// word by word
                    WordByWordAya(
                      words: ayaWords[index],
                      textScaleFactor: textScaleFactor,
                    ),

                    const SizedBox(height: 20),

                    /// translation
                    TranslationDisplay(
                      translation: translations.$2[index].text,
                      translationType: translations.$1,
                      textScaleFactor: textScaleFactor,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  SurahIndex _currentSuraIndex(int index) {
    return SurahIndex(pageData.page.firstAyaIndex.sura,
        pageData.page.firstAyaIndex.aya + index);
  }

  bool _isBookmarked(SurahIndex current, SurahIndex? bookmark) {
    return current == bookmark;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
