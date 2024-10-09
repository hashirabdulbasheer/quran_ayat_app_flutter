import 'package:ayat_app/src/core/constants/app_constants.dart';
import 'package:ayat_app/src/core/extensions/widget_spacer_extension.dart';
import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/presentation/home/bloc/home_bloc.dart';
import 'package:ayat_app/src/presentation/home/widgets/aya_control_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/translation_display_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/word_by_word_aya_widget.dart';
import 'package:ayat_app/src/presentation/widgets/scrollable_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AyaList extends StatelessWidget {
  final int selectableAya;
  final QPageData pageData;
  final double textScaleFactor;

  const AyaList({
    super.key,
    required this.pageData,
    required this.selectableAya,
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
      // max value other than infinity
      height: MediaQuery.of(context).size.height - 300,
      child: ScrollableListWidget(
          initialIndex: (selectableAya - (ayaWords[0][0].aya - 1)).abs(),
          itemsCount: pageData.ayaWords.length,
          itemContent: (index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Column(
                children: [
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

                  /// translation
                  TranslationDisplay(
                    translation: translations.$2[index].text,
                    translationType: translations.$1,
                    textScaleFactor: textScaleFactor,
                  ),
                ].spacerDirectional(height: 10),
              ),
            );
          }),
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
