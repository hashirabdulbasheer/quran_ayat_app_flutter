import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/ai/domain/ai_engine.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/misc/design/design_system.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

class QuranAIDisplayWidget extends StatelessWidget {
  final QuranAIEngine aiEngine;
  final SurahIndex currentIndex;
  final String translation;

  const QuranAIDisplayWidget({
    super.key,
    required this.aiEngine,
    required this.currentIndex,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    if (translation.isEmpty) {
      return const SizedBox.shrink();
    }

    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      bool isAiResponseDisplay = store.state.reader.isAIResponseVisible;
      if (isAiResponseDisplay) {
        return FutureBuilder<String?>(
            future: aiEngine.getResponse(
              question: "Help me think about and reflect on the $translation.",
            ),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data?.isEmpty == true ||
                  snapshot.connectionState != ConnectionState.done) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "thinking, please wait...",
                      style: QuranDS.textTitleMediumItalic,
                    ),
                  ],
                );
              }
              String? aiResponse = snapshot.data;
              if (aiResponse == null || aiResponse.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "AI Generated",
                        style: QuranDS.textTitleMediumLight,
                      ),
                      IconButton(
                          onPressed: () {
                            _shareResponse(
                              currentIndex,
                              translation,
                              aiResponse,
                            );
                          },
                          icon: const Icon(
                            Icons.share,
                            color: QuranDS.primaryColor,
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownBody(
                      selectable: true,
                      data: aiResponse,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(p: QuranDS.textTitleLarge),
                    ),
                  ),
                ],
              );
            });
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  store.dispatch(ShowAIResponseAction());
                },
                icon: const Icon(
                  Icons.assistant,
                  color: QuranDS.primaryColor,
                )),
          ],
        );
      }
    });
  }

  void _shareResponse(SurahIndex index, String translation, String response) {
    String shareString =
        "${index.human.sura}:${index.human.aya} $translation\n\n$response\n\nhttps://uxquran.com";
    Share.share(shareString);
  }
}
