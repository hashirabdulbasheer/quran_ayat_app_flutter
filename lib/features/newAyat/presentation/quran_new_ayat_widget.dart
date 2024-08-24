import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:quran_ayat/features/ai/domain/ai_cache.dart';
import 'package:quran_ayat/features/ai/domain/ai_engine.dart';
import 'package:quran_ayat/features/ai/domain/ai_type_enum.dart';
import 'package:quran_ayat/features/ai/domain/gemini_ai_engine.dart';
import 'package:quran_ayat/features/ai/presentation/ai_display_widget.dart';
import 'package:quran_ayat/features/ai/presentation/ai_trigger_widget.dart';
import 'package:redux/redux.dart';

import '../../../misc/design/design_system.dart';
import '../../../misc/enums/quran_app_mode_enum.dart';
import '../../../misc/router/router_utils.dart';
import '../../ayats/domain/enums/audio_events_enum.dart';
import '../../ayats/presentation/widgets/ayat_display_audio_controls_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_header_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_notes_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_surah_progress_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_translation_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_transliteration_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_word_by_word_widget.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../tags/presentation/quran_tag_display.dart';
import '../data/surah_index.dart';
import '../domain/redux/actions/actions.dart';

class QuranNewAyatReaderWidget extends StatefulWidget {
  const QuranNewAyatReaderWidget({super.key});

  @override
  State<QuranNewAyatReaderWidget> createState() =>
      _QuranNewAyatReaderWidgetState();
}

class _QuranNewAyatReaderWidgetState extends State<QuranNewAyatReaderWidget> {
  final String _aiApiKey = const String.fromEnvironment('AI_API_KEY');
  final AICache _aiCache = AILocalCache();
  late QuranAIEngine _aiEngine;

  @override
  void initState() {
    super.initState();
    _aiEngine = GeminiAI(apiKey: _aiApiKey);
    if (kIsWeb) {
      ServicesBinding.instance.keyboard.addHandler(_onKey);
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      ServicesBinding.instance.keyboard.removeHandler(_onKey);
    }
    super.dispose();
  }

  // Handle hardware keyboard events, for web only, to use hardware keyboard
  // to move between ayats on a desktop
  bool _onKey(KeyEvent event) {
    if (ModalRoute.of(context)?.isCurrent == false) {
      // do not handle key press if not this screen
      return false;
    }
    // right arrow key - back
    // left arrow key - next
    // space bar key - next
    // others ignore
    final key = event.logicalKey.keyLabel;
    var store = StoreProvider.of<AppState>(context);
    if (event is KeyDownEvent) {
      if (key == "Arrow Right") {
        store.dispatch(PreviousAyaAction());
      } else if (key == "Arrow Left" || key == " ") {
        store.dispatch(NextAyaAction());
      } else if (key == 'Audio Volume Up') {
        store.dispatch(PreviousAyaAction());
      } else if (key == 'Audio Volume Down') {
        store.dispatch(NextAyaAction());
      } else if (key == 'Media Track Previous') {
        store.dispatch(PreviousAyaAction());
      } else if (key == 'Media Track Next') {
        store.dispatch(NextAyaAction());
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      SurahIndex currentIndex = store.state.reader.currentIndex;
      NQSurahTitle currentSurahDetails =
          store.state.reader.currentSurahDetails();
      List<NQWord> ayaWords = store.state.reader.currentAyaWords();
      Map<NQTranslation, String> translations =
          store.state.reader.currentTranslations();
      String? transliteration = store.state.reader.currentTransliteration();

      if (store.state.reader.data.words.isEmpty) {
        // still loading
        return const Center(child: CircularProgressIndicator());
      }

      List<String>? recentTranslations =
          store.state.reader.getRecentAyaTranslations(2);

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// header
              store.state.reader.isHeaderVisible
                  ? QuranAyatHeaderWidget(
                      surahTitles: store.state.reader.surahTitles,
                      onSurahSelected: (surah) => store.dispatch(
                        SelectSurahAction(
                          index: SurahIndex.fromHuman(
                            sura: surah.number,
                            aya: 1,
                          ),
                        ),
                      ),
                      onAyaNumberSelected: (aya) =>
                          store.dispatch(SelectAyaAction(aya: aya)),
                      currentlySelectedSurah: currentSurahDetails,
                      currentIndex: currentIndex,
                    )
                  : Container(),

              // Surah title
              Container(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: store.state.reader.isHeaderVisible
                      ? QuranDS.arrowUp
                      : QuranDS.arrowDown,
                  label: Text(
                    "${currentSurahDetails.transliterationEn} / ${currentSurahDetails.translationEn}",
                    style: QuranDS.textTitleSmallLight,
                    textAlign: TextAlign.start,
                  ),
                  onPressed: () =>
                      store.dispatch(ToggleHeaderVisibilityAction()),
                ),
              ),

              /// surah progress
              Directionality(
                textDirection: TextDirection.rtl,
                child: QuranAyatDisplaySurahProgressWidget(
                  currentlySelectedSurah: currentSurahDetails,
                  currentIndex: currentIndex,
                ),
              ),

              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextButton(
                          onPressed: () =>
                              store.dispatch(ToggleHeaderVisibilityAction()),
                          child: Text(
                            "${currentIndex.human.sura}:${currentIndex.human.aya}",
                            // RTL
                            style: QuranDS.textTitleSmallLight,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: "Context aya list view",
                        onPressed: () => _navigateToContextListScreen(
                          store,
                          context,
                        ),
                        icon: QuranDS.listIconLightSmall,
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: "Increase font size",
                        onPressed: () => _incrementFontSize(store),
                        icon: QuranDS.addIconLightSmall,
                      ),
                      IconButton(
                        tooltip: "Decrease font size",
                        onPressed: () => _decrementFontSize(store),
                        icon: QuranDS.removeIconLightSmall,
                      ),
                      IconButton(
                        tooltip: "Reset font size",
                        onPressed: () => _resetFontSize(store),
                        icon: QuranDS.refreshIconLightSmall,
                      ),
                    ],
                  ),
                ),
              ),

              /// Bismillah
              store.state.reader.isBismillahDisplayed()
                  ? const Center(
                      child: Text(
                        "In the name of Allah, the Most Gracious, the Most Merciful",
                        textAlign: TextAlign.center,
                        style: QuranDS.textTitleSmall,
                      ),
                    )
                  : Container(),

              /// word by word widget
              ayaWords.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: QuranAyatDisplayWordByWordWidget(
                        words: ayaWords,
                      ),
                    )
                  : Container(),

              /// transliterationWidget if enabled
              transliteration != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: QuranAyatDisplayTransliterationWidget(
                        transliteration: transliteration,
                      ),
                    )
                  : Container(),

              /// translation widget
              for (NQTranslation type in translations.keys)
                QuranAyatDisplayTranslationWidget(
                  translation: translations[type] ?? "",
                  translationType: type,
                ),

              /// AI
              if (_aiApiKey.isNotEmpty) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ai triggers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: "AI Children",
                          child: QuranAITriggerWidget(
                            icon: QuranDS.aiChildrenIcon,
                            type: QuranAIType.childReflection,
                            isEnabled: !_isAILoading(
                                store, QuranAIType.childReflection),
                          ),
                        ),
                        Tooltip(
                          message: "AI Poetry",
                          child: QuranAITriggerWidget(
                            icon: QuranDS.aiPoetryIcon,
                            type: QuranAIType.poeticReflection,
                            isEnabled: !_isAILoading(
                              store,
                              QuranAIType.poeticReflection,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "AI Reflections",
                          child: QuranAITriggerWidget(
                            icon: QuranDS.aiReflectionIcon,
                            type: QuranAIType.reflection,
                            isEnabled: !_isAILoading(
                              store,
                              QuranAIType.reflection,
                            ),
                          ),
                        )
                      ],
                    ),
                    // ai responses
                    if (_isAILoading(store, QuranAIType.reflection)) ...[
                      QuranAIResponseWidget(
                        engine: _aiEngine,
                        cache: _aiCache,
                        type: QuranAIType.reflection,
                        currentIndex: currentIndex,
                        translation:
                            translations[NQTranslation.wahiduddinkhan] ?? "",
                        contextVerses: recentTranslations,
                        onReload: () {
                          _aiCache.removeResponse(
                            index: currentIndex,
                            type: QuranAIType.reflection,
                          );
                          setState(() {});
                        },
                      )
                    ],
                    if (_isAILoading(store, QuranAIType.poeticReflection)) ...[
                      QuranAIResponseWidget(
                        engine: _aiEngine,
                        cache: _aiCache,
                        type: QuranAIType.poeticReflection,
                        currentIndex: currentIndex,
                        translation:
                            translations[NQTranslation.wahiduddinkhan] ?? "",
                        // not passing any context for poetry
                        contextVerses: null,
                        onReload: () {
                          _aiCache.removeResponse(
                            index: currentIndex,
                            type: QuranAIType.poeticReflection,
                          );
                          setState(() {});
                        },
                      )
                    ],
                    if (_isAILoading(store, QuranAIType.childReflection)) ...[
                      QuranAIResponseWidget(
                        engine: _aiEngine,
                        cache: _aiCache,
                        type: QuranAIType.childReflection,
                        currentIndex: currentIndex,
                        translation:
                            translations[NQTranslation.wahiduddinkhan] ?? "",
                        contextVerses: recentTranslations,
                        onReload: () {
                          _aiCache.removeResponse(
                            index: currentIndex,
                            type: QuranAIType.childReflection,
                          );
                          setState(() {});
                        },
                      )
                    ],
                  ],
                )
              ],

              /// audio controls
              QuranAyatDisplayAudioControlsWidget(
                currentIndex: currentIndex,
                onAudioPlayStatusChanged: (event) => _onAudioPlayStatusChanged(
                  event,
                  store,
                ),
              ),

              /// Tags
              if (store.state.appMode == QuranAppMode.advanced)
                QuranAyatDisplayTagsWidget(
                  currentIndex: currentIndex,
                ),

              /// Notes
              if (store.state.appMode == QuranAppMode.advanced)
                QuranAyatDisplayNotesWidget(
                  currentIndex: currentIndex,
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      );
    });
  }

  void _navigateToContextListScreen(
    Store<AppState> store,
    BuildContext context,
  ) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args['title'] = store.state.reader.currentSurahDetails().transliterationEn;
    args['index'] = store.state.reader.currentIndex;
    int? selectedAyaIndex =
        await QuranNavigator.of(context).routeToContext(args);

    if (selectedAyaIndex != null) {
      store.dispatch(SelectAyaAction(aya: selectedAyaIndex));
    }
  }

  void _incrementFontSize(
    Store<AppState> store,
  ) {
    store.dispatch(IncreaseFontSizeAction());
  }

  void _decrementFontSize(
    Store<AppState> store,
  ) {
    store.dispatch(DecreaseFontSizeAction());
  }

  void _resetFontSize(
    Store<AppState> store,
  ) {
    store.dispatch(ResetFontSizeAction());
  }

  bool _isAILoading(Store<AppState> store, QuranAIType type) {
    return store.state.reader.aiResponseVisibility[type] == true;
  }

  ///
  /// Audio
  ///
  void _onAudioPlayStatusChanged(
    QuranAudioEventsEnum event,
    Store<AppState> store,
  ) {
    switch (event) {
      case QuranAudioEventsEnum.stopped:
        store.dispatch(SetAudioContinuousPlayMode(isEnabled: false));
        break;

      case QuranAudioEventsEnum.loadNext:
        store.dispatch(NextAyaAction());
        break;

      case QuranAudioEventsEnum.contPlayStatusChanged:
        // TODO: Cont. mode temporarily disabled
        store.dispatch(SetAudioContinuousPlayMode(
          isEnabled: false,
        ));
        break;

      default:
        break;
    }
  }
}
