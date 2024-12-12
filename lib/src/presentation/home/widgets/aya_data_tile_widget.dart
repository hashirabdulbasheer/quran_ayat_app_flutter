import 'dart:math';

import 'package:ayat_app/src/presentation/home/home.dart';
import 'package:file_saver/file_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class AyaDataTileWidget extends StatelessWidget {
  final QPageData pageData;
  final SurahIndex index;
  final bool isDetailed;
  final double textScaleFactor;

  const AyaDataTileWidget({
    super.key,
    required this.pageData,
    required this.index,
    this.isDetailed = false,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final ayaWords = pageData.ayaWords;
    final translations = pageData.translations[0];

    return ListTile(
      onTap: isDetailed
          ? null
          : () {
              context.push("/details/${index.human.sura}/${index.human.aya}");
            },
      title: Column(
        children: [
          /// index
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// aya controls
                if (!isDetailed) ...[
                  _AyaControls(
                    pageData: pageData,
                    index: index.aya,
                  ),
                ],

                /// index
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${index.human.sura}:${index.human.aya}",
                      style: const TextStyle(fontSize: 12),
                    )),
              ],
            ),
          ),

          /// word by word
          WordByWordAya(
            words: ayaWords[index.aya],
            textScaleFactor: textScaleFactor,
          ),

          const SizedBox(height: 20),

          /// translation
          TranslationDisplay(
            translation: translations.$2[index.aya].text,
            translationType: translations.$1,
            textScaleFactor: textScaleFactor,
          ),
        ],
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
            onScreenshot: () async {
              if (!context.mounted) return;
              try {
                Uint8List? image = await _captureScreenshot(context, pageData);
                if (image == null) {
                  throw (GeneralException("no image"));
                }
                await _saveScreenshot(image, _currentSuraIndex(index));
                _showMessage(context, "Screenshot saved");
              } catch (e) {
                _showMessage(context, "Error: ${e.toString()}");
              }
            },
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
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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

  Future<Uint8List?> _captureScreenshot(
    BuildContext context,
    QPageData pageData,
  ) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double width = MediaQuery.of(context).size.width;
    final widget = _ScreenshotWidget(pageData: pageData, index: index);
    final controller = ScreenshotController();
    return await controller.captureFromLongWidget(
      InheritedTheme.captureAll(context, Material(child: widget)),
      context: context,
      pixelRatio: pixelRatio,
      constraints: BoxConstraints(maxWidth: min(width, 600), maxHeight: 3000),
      delay: const Duration(milliseconds: 100),
    );
  }

  Future _saveScreenshot(Uint8List image, SurahIndex index) async {
    if (!kIsWeb) {
      return await _saveScreenshotMobile(image, index);
    }
    return await _saveScreenshotDesktop(image, index);
  }

  Future _saveScreenshotMobile(Uint8List image, SurahIndex index) async {
    Share.shareXFiles([
      XFile.fromData(image, mimeType: 'image/png')
    ], fileNameOverrides: [
      "quran_${index.human.sura}_${index.human.aya}.png"
    ]);
  }

  Future _saveScreenshotDesktop(Uint8List image, SurahIndex index) async {
    await FileSaver.instance.saveFile(
        bytes: image, name: "quran_${index.human.sura}_${index.human.aya}.png");
  }
}

class _ScreenshotWidget extends StatelessWidget {
  final QPageData pageData;
  final int index;

  const _ScreenshotWidget({
    required this.pageData,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ayaWords = pageData.ayaWords;
    final translations = pageData.translations[0];
    final firstAyaIndex = pageData.page.firstAyaIndex;
    return MediaQuery(
      data: const MediaQueryData(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// index
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${firstAyaIndex.human.sura}:${firstAyaIndex.human.aya + index}",
                    style: const TextStyle(fontSize: 12),
                  )),
            ),

            /// word by word
            WordByWordAya(
              words: ayaWords[index],
              textScaleFactor: 1.0,
            ),

            const SizedBox(height: 20),

            /// translation
            TranslationDisplay(
              translation: translations.$2[index].text,
              translationType: translations.$1,
              textScaleFactor: 1.0,
            ),

            const SizedBox(height: 30),

            /// branding
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "https://uxquran.com",
                  style: TextStyle(
                      color: Theme.of(context).disabledColor, fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
