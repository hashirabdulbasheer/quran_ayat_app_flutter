import 'package:ayat_app/src/presentation/home/home.dart';

class AyaList extends StatelessWidget {
  final int selectableAya;
  final QPageData pageData;
  final double textScaleFactor;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final SurahIndex? bookmarkIndex;

  const AyaList({
    super.key,
    required this.pageData,
    required this.selectableAya,
    required this.onNext,
    required this.onBack,
    this.textScaleFactor = 1.0,
    this.bookmarkIndex,
  });

  @override
  Widget build(BuildContext context) {
    final ayaWords = pageData.ayaWords;
    final translations = pageData.translations[0];

    if (ayaWords.isEmpty || translations.$2.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstAyaIndex = pageData.page.firstAyaIndex;

    return Expanded(
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
                child: AyaNavigationControl(onNext: onNext, onBack: onBack,),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Column(
                children: [
                  /// index
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// aya controls
                      _AyaControls(
                        pageData: pageData,
                        index: index,
                      ),

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
          },
        ),
      ),
    );
  }
}

class _AyaControls extends StatelessWidget {
  final QPageData pageData;
  final int index;

  const _AyaControls({
    required this.index,
    required this.pageData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final translations = pageData.translations.first;
        final firstAyaIndex = pageData.page.firstAyaIndex;

        return AyaControlWidget(
            onCopy: () {
              String shareableString = _getShareableString(
                context,
                _currentSuraIndex(index),
                translations.$2[index].text,
              );
              Clipboard.setData(
                ClipboardData(text: shareableString),
              ).then((_) {
                if (context.mounted) {
                  _showMessage(context, "Copied to clipboard");
                }
              });
            },
            onMore: () {
              launchUrl(
                  Uri.parse(
                      "$kLegacyAppUrl/${firstAyaIndex.human.sura}/${_currentSuraIndex(index).human.aya}"),
                  mode: LaunchMode.inAppBrowserView);
            },
            onBookmarked: () {
              context.read<HomeBloc>().add(
                    AddBookmarkEvent(index: _currentSuraIndex(index)),
                  );
              _showMessage(context, "Bookmark saved");
            },
            isBookmarked: _isBookmarked(
              _currentSuraIndex(index),
              (state as HomeLoadedState).bookmarkIndex,
            ));
      },
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

  String _getShareableString(
    BuildContext context,
    SurahIndex index,
    String translationText,
  ) {
    final bloc = context.read<HomeBloc>();
    final suraName =
        (bloc.state as HomeLoadedState).suraTitles?[index.sura].translationEn;
    StringBuffer response = StringBuffer();
    response.write("Sura $suraName - ${index.human.sura}:${index.human.aya}\n");
    response.write("$translationText\n");
    response
        .write("https://uxquran.com/${index.human.sura}/${index.human.aya}\n");
    return response.toString();
  }
}
