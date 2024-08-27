import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:quran_ayat/features/ai/domain/ai_cache.dart';
import 'package:quran_ayat/features/ai/domain/ai_engine.dart';
import 'package:quran_ayat/features/ai/domain/ai_type_enum.dart';
import 'package:quran_ayat/features/ai/presentation/ai_display_widget.dart';
import 'package:quran_ayat/features/ai/presentation/ai_trigger_widget.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/misc/design/design_system.dart';
import 'package:redux/redux.dart';

class QuranAIActionsRowWidget extends StatelessWidget {
  final Store<AppState> store;
  final QuranAIEngine engine;
  final AICache cache;

  const QuranAIActionsRowWidget({
    super.key,
    required this.store,
    required this.engine,
    required this.cache,
  });

  @override
  Widget build(BuildContext context) {
    QuranAIType? currentType = _getCurrentlyLoadingType(store);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // AI triggers
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Tooltip(
              message: "AI Children",
              child: QuranAITriggerWidget(
                icon: QuranDS.aiChildrenIcon,
                type: QuranAIType.childReflection,
                isEnabled: currentType != QuranAIType.childReflection,
              ),
            ),
            Tooltip(
              message: "AI Poetry",
              child: QuranAITriggerWidget(
                icon: QuranDS.aiPoetryIcon,
                type: QuranAIType.poeticReflection,
                isEnabled: currentType != QuranAIType.poeticReflection,
              ),
            ),
            Tooltip(
              message: "AI Reflections",
              child: QuranAITriggerWidget(
                icon: QuranDS.aiReflectionIcon,
                type: QuranAIType.reflection,
                isEnabled: currentType != QuranAIType.reflection,
              ),
            )
          ],
        ),

        // ai responses
        if (currentType != null) ...[
          QuranAIResponseWidget(
            engine: engine,
            cache: cache,
            type: currentType,
            currentIndex: _getCurrentIndex(store),
            translation: _getTranslation(store),
            contextVerses: currentType != QuranAIType.poeticReflection
                ? _getRecentTranslations(store)
                : null,
          )
        ],
      ],
    );
  }

  List<String>? _getRecentTranslations(Store<AppState> store) {
    // returns last two translations has the context
    return store.state.reader.getRecentAyaTranslations(2);
  }

  String _getTranslation(Store<AppState> store) {
    return store.state.reader
            .currentTranslations()[NQTranslation.wahiduddinkhan] ??
        "";
  }

  SurahIndex _getCurrentIndex(Store<AppState> store) {
    return store.state.reader.currentIndex;
  }

  QuranAIType? _getCurrentlyLoadingType(Store<AppState> store) {
    if (store.state.reader.aiResponseVisibility.isEmpty) {
      return null;
    }
    return store.state.reader.aiResponseVisibility.keys.first;
  }
}
