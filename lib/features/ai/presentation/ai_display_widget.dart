import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/ai/domain/ai_cache.dart';
import 'package:quran_ayat/features/ai/domain/ai_engine.dart';
import 'package:quran_ayat/features/ai/domain/ai_type_enum.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/features/newAyat/domain/redux/actions/actions.dart';
import 'package:quran_ayat/misc/design/design_system.dart';
import 'package:quran_ayat/utils/logger_utils.dart';
import 'package:share_plus/share_plus.dart';

class QuranAIResponseWidget extends StatelessWidget {
  final QuranAIEngine engine;
  final AICache cache;
  final QuranAIType type;
  final SurahIndex currentIndex;
  final String translation;

  const QuranAIResponseWidget({
    super.key,
    required this.engine,
    required this.cache,
    required this.type,
    required this.currentIndex,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: cache.getResponse(index: currentIndex, type: type),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _AIWaitingWidget();
          } else if (snapshot.hasData) {
            String? cacheResponse = snapshot.data;
            if (cacheResponse != null && cacheResponse.isNotEmpty) {
              return _AIDataWidget(
                currentIndex: currentIndex,
                translation: translation,
                aiResponse: cacheResponse,
              );
            }
          }
          return _AIEngineResponseWidget(
            engine: engine,
            currentIndex: currentIndex,
            translation: translation,
            type: type,
            onResponse: (response) {
              cache.saveResponse(
                index: currentIndex,
                type: type,
                response: response,
              );
            },
          );
        });
  }
}

///
/// Local Widgets
///

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

class _AIEngineResponseWidget extends StatelessWidget {
  final QuranAIEngine engine;
  final QuranAIType type;
  final SurahIndex currentIndex;
  final String translation;
  final Function(String)? onResponse;

  const _AIEngineResponseWidget({
    required this.engine,
    required this.type,
    required this.translation,
    required this.currentIndex,
    this.onResponse,
  });

  @override
  Widget build(BuildContext context) {
    String prompt = _getPromptFromType(type, translation);
    return FutureBuilder<String?>(
        future: engine.getResponse(
          currentIndex: currentIndex,
          question: prompt,
        ),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _AIWaitingWidget();
          } else if (snapshot.hasData) {
            String? aiResponse = snapshot.data;
            if (aiResponse != null) {
              onResponse?.call(aiResponse);
              return _AIDataWidget(
                currentIndex: currentIndex,
                translation: translation,
                aiResponse: aiResponse,
              );
            }
          }
          return const _AIErrorWidget();
        });
  }

  String _getPromptFromType(QuranAIType type, String translation) {
    switch (type) {
      case QuranAIType.reflection:
        return "Help me think about and reflect on this verse from Quran - $translation.";
      case QuranAIType.poeticInterpretation:
        return "";
    }
  }
}
