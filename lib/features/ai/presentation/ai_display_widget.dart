import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/common/presentation/widgets/header_widget.dart';
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
  final List<String>? contextVerses;
  final void Function() onReload;

  const QuranAIResponseWidget({
    super.key,
    required this.engine,
    required this.cache,
    required this.type,
    required this.currentIndex,
    required this.translation,
    required this.contextVerses,
    required this.onReload,
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
                onReload: onReload,
              );
            }
          }
          return _AIEngineResponseWidget(
            engine: engine,
            currentIndex: currentIndex,
            translation: translation,
            contextVerses: contextVerses,
            type: type,
            onReload: onReload,
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
  final void Function() onReload;

  const _AIDataWidget({
    required this.currentIndex,
    required this.translation,
    required this.aiResponse,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    String? response = aiResponse;
    if (response == null || response.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuranHeaderWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "AI Generated",
                style: QuranDS.textTitleMediumLight,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: onReload,
                      icon: const Icon(
                        Icons.refresh,
                        color: QuranDS.primaryColor,
                      )),
                  IconButton(
                      onPressed: () => _copyResponse(
                          context, currentIndex, translation, response),
                      icon: const Icon(
                        Icons.copy,
                        color: QuranDS.primaryColor,
                      )),
                  IconButton(
                      onPressed: () =>
                          _shareResponse(currentIndex, translation, response),
                      icon: const Icon(
                        Icons.share,
                        color: QuranDS.primaryColor,
                      )),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
          child: MarkdownBody(
            selectable: true,
            softLineBreak: true,
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
        "${index.human.sura}:${index.human.aya} $translation\n\n$response\n\nhttps://uxquran.com/${index.human.sura}/${index.human.aya}";
    Share.share(shareString);
  }

  void _copyResponse(BuildContext context, SurahIndex index, String translation,
      String response) {
    String shareString =
        "${index.human.sura}:${index.human.aya} $translation\n\n$response\n\nhttps://uxquran.com/${index.human.sura}/${index.human.aya}";
    Clipboard.setData(ClipboardData(text: shareString)).then((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
    });
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
            "ai ai o... please wait...",
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
  final List<String>? contextVerses;
  final Function(String)? onResponse;
  final void Function() onReload;

  const _AIEngineResponseWidget({
    required this.engine,
    required this.type,
    required this.translation,
    required this.currentIndex,
    required this.contextVerses,
    required this.onReload,
    this.onResponse,
  });

  @override
  Widget build(BuildContext context) {
    String prompt = _generatePrompt(type, translation, contextVerses);
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
                onReload: onReload,
              );
            }
          }
          return const _AIErrorWidget();
        });
  }

  String _generatePrompt(
    QuranAIType type,
    String translation,
    List<String>? contextVerses,
  ) {
    String context = contextVerses?.isNotEmpty == true
        ? "The previous verses for context are:\n${contextVerses?.join('\n')}"
        : "";
    switch (type) {
      case QuranAIType.reflection:
        return "Help me think about and reflect on this verse from Quran - $translation.\n\n$context";
      case QuranAIType.poeticReflection:
        return "Write a short poem reflecting on this Quran verse:\n$translation.\n\n$context";
      case QuranAIType.childReflection:
        return "Make this verse from the quran easier to understand for children:\n$translation.\n\n$context";
    }
  }
}
