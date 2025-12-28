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
          key: ValueKey(pageData.page.number),
          initialIndex: (selectableAya - (ayaWords[0][0].aya - 1)).abs(),
          itemsCount: pageData.page.numberOfAya + 1,
          itemContent: (index) {
            if (index == pageData.page.numberOfAya) {
              // we are at the last index, show controls
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AyaNavigationControl(
                  onNext: onNext,
                  onBack: onBack,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (firstAyaIndex.aya == 0 &&
                    index == 0 &&
                    _isBismillahAllowed(pageData.page.firstAyaIndex)) ...[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "In the name of God, the Most Gracious, the Most Merciful",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
                if (index == 0) ...[
                  _PageControls(
                    onBack: onBack,
                    onCopyPage: () => _copyPage(context),
                  )
                ],
                AyaDataTileWidget(
                  pageData: pageData,
                  index:
                      SurahIndex(firstAyaIndex.sura, firstAyaIndex.aya + index),
                  textScaleFactor: textScaleFactor,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isBismillahAllowed(SurahIndex index) {
    /// no bismillah manually for fatihah and tawba sura
    return index.sura != 0 && index.sura != 8;
  }

  void _copyPage(BuildContext context) {
    StringBuffer buffer = StringBuffer();
    for (var index = 0; index < pageData.translations[0].$2.length; index++) {
      final aya = pageData.translations[0].$2[index];
      final suraIndex = SurahIndex(
        pageData.page.firstAyaIndex.sura,
        pageData.page.firstAyaIndex.aya + index,
      );
      final copyString = _getShareableString(context, suraIndex, aya.text);
      buffer.write('$copyString\n');
    }
    Clipboard.setData(
      ClipboardData(text: buffer.toString()),
    ).then((_) {
      if (context.mounted) {
        _showMessage(context, "Copied page to clipboard");
      }
    });
  }

  String _getShareableString(
    BuildContext context,
    SurahIndex index,
    String translationText,
  ) {
    final bloc = context.read<HomeBloc>();
    final suraName = (bloc.state as HomeLoadedState)
        .suraTitles?[index.sura]
        .transliterationEn;
    StringBuffer response = StringBuffer();
    response.write("Sura $suraName - ${index.human.sura}:${index.human.aya}\n");
    response.write("$translationText\n");
    response
        .write("https://uxquran.com/${index.human.sura}/${index.human.aya}\n");
    return response.toString();
  }

  void _showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PageControls extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCopyPage;

  const _PageControls({
    required this.onBack,
    required this.onCopyPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              tooltip: "Copy page",
              onPressed: onCopyPage,
              icon: Icon(
                Icons.copy,
                size: 18,
                color: Theme.of(context).disabledColor,
              ),
            ),
            const _ToggleWordTranslationStatusButton(),
          ],
        ),
        IconButton(
          tooltip: "Back to previous page",
          onPressed: onBack,
          icon: const Icon(
            Icons.arrow_forward,
            size: 18,
          ),
        ),
      ],
    );
  }
}

class _ToggleWordTranslationStatusButton extends StatelessWidget {
  const _ToggleWordTranslationStatusButton();

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = context.read<HomeBloc>();
    return StreamBuilder<QPageData?>(
        stream: bloc.currentPageData$,
        initialData: bloc.currentPageData$.value,
        builder: (context, snapshot) {
          bool isEnabled = snapshot.hasData ? snapshot.data?.isWordByWordTranslationEnabled as bool : true;
          return IconButton(
            tooltip: "Toggle Word by word translations",
            onPressed: snapshot.hasData
                ? () => bloc.add(ToggleWordTranslationStatusEvent())
                : null,
            icon: Icon(
              Icons.language,
              size: 18,
              color: isEnabled
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
            ),
          );
        });
  }
}
