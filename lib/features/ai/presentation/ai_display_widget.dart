import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/ai/domain/ai_cache.dart';
import 'package:quran_ayat/features/ai/domain/ai_engine.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/misc/design/design_system.dart';
import 'package:quran_ayat/utils/logger_utils.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

class QuranAIDisplayWidget extends StatelessWidget {
  final QuranAIEngine aiEngine;
  final AICache? aiCache;
  final SurahIndex currentIndex;
  final String translation;

  const QuranAIDisplayWidget({
    super.key,
    required this.aiEngine,
    required this.currentIndex,
    required this.translation,
    this.aiCache,
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
      if (!store.state.reader.isAIResponseVisible) {
        return const _AITriggerIcon();
      }
      return FutureBuilder<String?>(
          future: _getAIResponse(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _AIWaitingWidget();
            } else if (snapshot.hasData) {
              String? aiResponse = snapshot.data;
              return _AIDataWidget(
                currentIndex: currentIndex,
                translation: translation,
                aiResponse: aiResponse,
              );
            } else {
              return const _AIErrorWidget();
            }
          });
    });
  }

  Future<String?> _getAIResponse() async {
    String? response;
    // try cache
    response = await aiCache?.getResponse(currentIndex);
    if (response == null || response.isEmpty) {
      // there isn't any cached response, fetch it
      response = await aiEngine.getResponse(
        currentIndex: currentIndex,
        question: "Help me think about and reflect on the $translation.",
      );

      // save in cache for future use
      if (response != null && response.isNotEmpty) {
        aiCache?.saveResponse(currentIndex, response);
      }
    }
    return response;
  }
}

///
/// Local Widgets
///

class _AITriggerIcon extends StatelessWidget {
  const _AITriggerIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              StoreProvider.of<AppState>(context)
                  .dispatch(ShowAIResponseAction());
              QuranLogger.logAnalytics("ai-tapped");
            },
            icon: QuranDS.aiIcon,
          ),
        ],
      ),
    );
  }
}

class _AIDataWidget extends StatelessWidget {
  final SurahIndex currentIndex;
  final String translation;
  final String? aiResponse;

  const _AIDataWidget({
    required this.currentIndex,
    required this.translation,
    required this.aiResponse,
  });

  @override
  Widget build(BuildContext context) {
    String? response = aiResponse;
    if (response == null || response.isEmpty) {
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
                onPressed: () =>
                    _shareResponse(currentIndex, translation, response),
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
            data: response,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(p: QuranDS.textTitleLarge),
          ),
        ),
      ],
    );
  }

  void _shareResponse(SurahIndex index, String translation, String response) {
    String shareString =
        "${index.human.sura}:${index.human.aya} $translation\n\n$response\n\nhttps://uxquran.com";
    Share.share(shareString);
  }
}

class _AIWaitingWidget extends StatelessWidget {
  const _AIWaitingWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "thinking, please wait...",
            style: QuranDS.textTitleMediumItalic,
          ),
        ],
      ),
    );
  }
}

class _AIErrorWidget extends StatelessWidget {
  const _AIErrorWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: () {
          StoreProvider.of<AppState>(context).dispatch(ShowLoadingAction());
          StoreProvider.of<AppState>(context).dispatch(HideLoadingAction());
          QuranLogger.logAnalytics("ai-retry-tapped");
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            QuranDS.refreshIconLightSmall,
            Text(
              "Sorry, there is a problem using AI at the moment, try again.",
              style: QuranDS.textTitleMediumItalic,
            ),
          ],
        ),
      ),
    );
  }
}
