import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:quran_ayat/features/bookmark/domain/bookmarks_manager.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:redux/redux.dart';

import '../../../misc/enums/quran_app_mode_enum.dart';
import '../../ayats/domain/enums/audio_events_enum.dart';
import '../../ayats/presentation/widgets/ayat_display_audio_controls_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_header_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_notes_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_surah_progress_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_translation_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_transliteration_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_word_by_word_widget.dart';
import '../../bookmark/data/bookmarks_local_impl.dart';
import '../../bookmark/presentation/bookmark_icon_widget.dart';
import '../../contextList/presentation/quran_context_list_screen.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../drawer/presentation/nav_drawer.dart';
import '../../settings/domain/settings_manager.dart';
import '../../settings/domain/theme_manager.dart';
import '../../tags/presentation/quran_tag_display.dart';
import '../domain/redux/actions/actions.dart';

class QuranNewAyatScreen extends StatefulWidget {
  const QuranNewAyatScreen({Key? key}) : super(key: key);

  @override
  State<QuranNewAyatScreen> createState() => _QuranNewAyatScreenState();
}

class _QuranNewAyatScreenState extends State<QuranNewAyatScreen> {
  bool _isHeaderVisible = false;

  @override
  void initState() {
    super.initState();
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
        return Container();
      }

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: QuranNavDrawer(
            user: store.state.user,
            bookmarksManager: QuranBookmarksManager(
              localEngine: QuranLocalBookmarksEngine(),
            ),
          ),
          // onDrawerChanged: null,
          bottomSheet: Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              10,
              10,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: "Previous aya",
                        child: ElevatedButton(
                          style: _elevatedButtonTheme,
                          onPressed: () => _moveToPreviousAyat(
                            store,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: _elevatedButtonIconColor(
                              context,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Tooltip(
                        message: "Next aya",
                        child: ElevatedButton(
                          style: _elevatedButtonTheme,
                          onPressed: () => _moveToNextAyat(
                            store,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: _elevatedButtonIconColor(
                              context,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Quran"),
            actions: [
              IconButton(
                tooltip: "Share",
                onPressed: () => store.dispatch(ShareAyaAction()),
                icon: const Icon(Icons.share),
              ),
              IconButton(
                tooltip: "Random verse",
                onPressed: () => store.dispatch(RandomAyaAction()),
                icon: const Icon(Icons.auto_awesome_outlined),
              ),
              QuranBookmarkIconWidget(
                currentIndex: currentIndex,
              ),
            ],
          ),
          body: SingleChildScrollView(
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
                  _isHeaderVisible
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      !_isHeaderVisible
                          ? Expanded(
                              child: SizedBox(
                                height: 30,
                                child: TextButton(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${currentSurahDetails.transliterationEn} / ${currentSurahDetails.translationEn}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  onPressed: () => _toggleHeader(),
                                ),
                              ),
                            )
                          : IconButton(
                              tooltip: "Close header",
                              onPressed: () => _toggleHeader(),
                              icon: const Icon(
                                Icons.close,
                                size: 12,
                              ),
                            ),
                    ],
                  ),

                  /// surah progress
                  QuranAyatDisplaySurahProgressWidget(
                    currentlySelectedSurah: currentSurahDetails,
                    currentIndex: currentIndex,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _toggleHeader(),
                          child: Text(
                            "${currentIndex.human.sura}:${currentIndex.human.aya}",
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: "Context aya list view",
                          onPressed: () => _navigateToContextListScreen(
                            store,
                            context,
                          ),
                          icon: const Icon(
                            Icons.list_alt,
                            size: 15,
                            color: Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: "Increase font size",
                          onPressed: () => _incrementFontSize(store),
                          icon: const Icon(
                            Icons.add,
                            size: 15,
                            color: Colors.black54,
                          ),
                        ),
                        IconButton(
                          tooltip: "Decrease font size",
                          onPressed: () => _decrementFontSize(store),
                          icon: const Icon(
                            Icons.remove,
                            size: 15,
                            color: Colors.black54,
                          ),
                        ),
                        IconButton(
                          tooltip: "Reset font size",
                          onPressed: () => _resetFontSize(store),
                          icon: const Icon(
                            Icons.refresh,
                            size: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Bismillah
                  store.state.reader.isBismillahDisplayed()
                      ? const Center(
                          child: Text(
                            "In the name of Allah, the Most Gracious, the Most Merciful",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
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
                      ? QuranAyatDisplayTransliterationWidget(
                          transliteration: transliteration,
                        )
                      : Container(),

                  /// translation widget
                  for (NQTranslation type in translations.keys)
                    QuranAyatDisplayTranslationWidget(
                      translation: translations[type] ?? "",
                      translationType: type,
                    ),

                  /// audio controls
                  QuranAyatDisplayAudioControlsWidget(
                    currentIndex: currentIndex,
                    onAudioPlayStatusChanged: (event) =>
                        _onAudioPlayStatusChanged(
                      event,
                      store,
                    ),
                  ),

                  /// Tags
                  FutureBuilder<QuranAppMode>(
                    future: QuranSettingsManager.instance.getAppMode(),
                    builder: (
                        context,
                        snapshot,
                        ) {
                      if (snapshot.hasData) {
                        QuranAppMode mode = snapshot.data as QuranAppMode;
                        if (mode == QuranAppMode.advanced) {
                          return QuranAyatDisplayTagsWidget(
                            currentIndex: currentIndex,
                          );
                        }
                      }

                      return Container();
                    },
                  ),

                  /// Notes
                  FutureBuilder<QuranAppMode>(
                    future: QuranSettingsManager.instance.getAppMode(),
                    builder: (
                        context,
                        snapshot,
                        ) {
                      if (snapshot.hasData) {
                        QuranAppMode mode = snapshot.data as QuranAppMode;
                        if (mode == QuranAppMode.advanced) {
                          return QuranAyatDisplayNotesWidget(
                            currentIndex: currentIndex,
                          );
                        }
                      }

                      return Container();
                    },
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _navigateToContextListScreen(
    Store<AppState> store,
    BuildContext context,
  ) async {
    int? selectedAyaIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranContextListScreen(
          title: store.state.reader.currentSurahDetails().transliterationEn,
          index: store.state.reader.currentIndex,
        ),
      ),
    );

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

  /// display next aya
  void _moveToNextAyat(
    Store<AppState> store,
  ) {
    store.dispatch(NextAyaAction());
    _closeHeader();
  }

  /// display previous aya
  void _moveToPreviousAyat(
    Store<AppState> store,
  ) {
    store.dispatch(PreviousAyaAction());
    _closeHeader();
  }

  ///
  /// Theme
  ///

  ButtonStyle? get _elevatedButtonTheme {
    // if system dark mode is set then use dark mode buttons
    // else use gray button
    if (QuranThemeManager.instance.isDarkMode()) {
      return ElevatedButton.styleFrom(
        backgroundColor: Colors.white70,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(color: Colors.black),
      );
    }

    return ElevatedButton.styleFrom(
      backgroundColor: Colors.black12,
      shadowColor: Colors.transparent,
      textStyle: const TextStyle(color: Colors.deepPurple),
    );
  }

  Color? _elevatedButtonIconColor(
    BuildContext context,
  ) {
    // if system dark mode is set then use dark mode buttons
    // else use primate color
    if (QuranThemeManager.instance.isDarkMode()) {
      return null;
    }

    return Theme.of(context).primaryColor;
  }

  void _toggleHeader() {
    _isHeaderVisible = !_isHeaderVisible;
    setState(() {});
  }

  void _closeHeader() {
    _isHeaderVisible = false;
    setState(() {});
  }
}
