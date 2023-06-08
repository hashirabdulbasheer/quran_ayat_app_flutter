import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/features/contextList/presentation/quran_context_list_screen.dart';
import 'package:quran_ayat/utils/logger_utils.dart';
import 'features/auth/domain/auth_factory.dart';
import 'features/ayats/domain/enums/audio_events_enum.dart';
import 'features/ayats/presentation/widgets/ayat_display_audio_controls_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_header_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_notes_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_surah_progress_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_translation_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_transliteration_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_word_by_word_widget.dart';
import 'features/bookmark/data/firebase_bookmarks_impl.dart';
import 'features/bookmark/domain/bookmarks_manager.dart';
import 'features/bookmark/presentation/bookmark_icon_widget.dart';
import 'features/drawer/presentation/nav_drawer.dart';
import 'features/notes/domain/notes_manager.dart';
import 'features/settings/domain/settings_manager.dart';
import 'features/settings/domain/theme_manager.dart';
import 'misc/constants/string_constants.dart';
import 'models/qr_user_model.dart';
import 'quran_search_screen.dart';
import 'utils/utils.dart';

class QuranAyatScreen extends StatefulWidget {
  final int? surahIndex;
  final int? ayaIndex;

  final QuranBookmarksManager bookmarksManager;

  const QuranAyatScreen({
    Key? key,
    this.surahIndex,
    this.ayaIndex,
    required this.bookmarksManager,
  }) : super(key: key);

  @override
  QuranAyatScreenState createState() => QuranAyatScreenState();
}

class QuranAyatScreenState extends State<QuranAyatScreen> {
  /// list of all surah titles
  List<NQSurahTitle> _surahTitles = [];

  /// current selected surah
  NQSurahTitle? _selectedSurah;

  /// current selected ayat
  int _selectedAyat = 1;

  /// url parameters
  final String? _urlQuerySearchString = Uri.base.queryParameters["search"];
  final String? _urlQuerySuraIndex = Uri.base.queryParameters["sura"];
  final String? _urlQueryAyaIndex = Uri.base.queryParameters["aya"];

  /// audio recitation continuous play mode state
  final ValueNotifier<bool> _isAudioContinuousModeEnabled =
      ValueNotifier(false);

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

  Color? get _elevatedButtonIconColor {
    // if system dark mode is set then use dark mode buttons
    // else use primate color
    if (QuranThemeManager.instance.isDarkMode()) {
      return null;
    }

    return Theme.of(context).primaryColor;
  }

  @override
  void initState() {
    super.initState();

    /// if an aya index is passed in then use that
    _selectedAyat = widget.ayaIndex ?? 1;

    /// load surah titles and handle web url params when ready
    NobleQuran.getSurahList().then((surahList) {
      setState(() {
        _surahTitles = surahList;
      });
      _handleUrlPathsForWeb();
    });

    /// register for auth changes
    QuranAuthFactory.engine.registerAuthChangeListener(_authChangeListener);

    // register for settings changes
    QuranSettingsManager.instance.registerListener(_settingsChangedListener);

    // calling it once manually to initialize notes/bookmarks
    _authChangeListener();
  }

  @override
  void dispose() {
    super.dispose();
    QuranAuthFactory.engine?.unregisterAuthChangeListener(_authChangeListener);
    QuranSettingsManager.instance.removeListeners();
    _isAudioContinuousModeEnabled.value = false;
    _isAudioContinuousModeEnabled.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? surahIndex = _selectedSurah?.number;
    if (surahIndex != null) {
      surahIndex = surahIndex - 1;
    } else {
      surahIndex = 0;
    }

    if (_surahTitles.isNotEmpty) {
      _selectedSurah ??= _surahTitles[widget.surahIndex ?? 0];
    }

    return Semantics(
      textDirection: TextDirection.rtl,
      enabled: true,
      container: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: widget.surahIndex == null
              ? QuranNavDrawer(
                  user: QuranAuthFactory.engine?.getUser(),
                  bookmarksManager: widget.bookmarksManager,
                )
              : null,
          onDrawerChanged: (isOpened) => {
            // drawer opened - stop continuous play
            setState(() {
              _isAudioContinuousModeEnabled.value = false;
            }),
          },
          bottomSheet: Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              10,
              10,
              10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: _elevatedButtonTheme,
                        onPressed: () => {
                          if (_isInteractionAllowedOnScreen())
                            {_moveToPreviousAyat()}
                          else
                            {_showMessage(QuranStrings.contPlayMessage)},
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: _elevatedButtonIconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: _elevatedButtonTheme,
                        onPressed: () => {
                          if (_isInteractionAllowedOnScreen())
                            {_moveToNextAyat()}
                          else
                            {_showMessage(QuranStrings.contPlayMessage)},
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: _elevatedButtonIconColor,
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
                tooltip: "Copy to clipboard",
                onPressed: () => _onCopyToClipboardIconPressed(context),
                icon: const Icon(Icons.share),
              ),
              IconButton(
                tooltip: "Random verse",
                onPressed: () => _randomVersePressed(),
                icon: const Icon(Icons.auto_awesome_outlined),
              ),
              QuranBookmarkIconWidget(
                bookmarksManager: widget.bookmarksManager,
                currentSurahIndex: surahIndex,
                currentAyaIndex: _selectedAyat,
                onSaveButtonPressed: () => {
                  if (_isInteractionAllowedOnScreen())
                    {_saveBookmarkDialogAction()}
                  else
                    {_showMessage(QuranStrings.contPlayMessage)},
                },
                onClearButtonPressed: () => _onBookmarkCleared(context),
                onGoToButtonPressed: (NQBookmark? bookmark) =>
                    _navigateToBookmark(bookmark),
              ),
            ],
          ),
          body: _surahTitles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      10,
                    ),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /// header
                            QuranAyatHeaderWidget(
                              surahTitles: _surahTitles,
                              onSurahSelected: (surah) => {
                                setState(() {
                                  if (surah != null) {
                                    _selectedSurah = surah;
                                    _selectedAyat = 1;
                                  }
                                }),
                              },
                              onAyaNumberSelected: (aya) => {
                                setState(() {
                                  _selectedAyat = aya ?? 1;
                                }),
                              },
                              continuousMode: _isAudioContinuousModeEnabled,
                              currentlySelectedAya: _selectedAyat,
                              currentlySelectedSurah: _selectedSurah,
                            ),

                            /// surah progress
                            QuranAyatDisplaySurahProgressWidget(
                              currentlySelectedSurah: _selectedSurah,
                              currentlySelectedAya: _selectedAyat,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(onPressed: _navigateToContextListScreen, icon: const Icon(Icons.list_alt, size: 15,),),
                                  const Spacer(),
                                  IconButton(onPressed: _incrementFontSize, icon: const Icon(Icons.add, size: 15,),),
                                  IconButton(onPressed: _decrementFontSize, icon: const Icon(Icons.remove, size: 15,),),
                                  IconButton(onPressed: _resetFontSize, icon: const Icon(Icons.refresh, size: 15,),),
                              ],),
                            ),

                            /// body
                            Card(
                              elevation: 5,
                              child: FutureBuilder<List<List<NQWord>>>(
                                future: NobleQuran.getSurahWordByWord(
                                  (_selectedSurah?.number ?? 1) - 1,
                                ),
                                // async work
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<List<List<NQWord>>> snapshot,
                                ) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return SizedBox(
                                        height: 300,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Center(
                                          child: Text('Loading....'),
                                        ),
                                      );
                                    default:
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        List<List<NQWord>> surahWords =
                                            snapshot.data as List<List<NQWord>>;

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child:
                                              QuranAyatDisplayWordByWordWidget(
                                            words:
                                                surahWords[_selectedAyat - 1],
                                            continuousMode:
                                                _isAudioContinuousModeEnabled,
                                          ),
                                        );
                                      }
                                  }
                                },
                              ),
                            ),

                            // transliterationWidget if enabled
                            QuranAyatDisplayTransliterationWidget(
                              currentlySelectedSurah: _selectedSurah,
                              currentlySelectedAya: _selectedAyat,
                            ),

                            // translation widget
                            QuranAyatDisplayTranslationWidget(
                              currentlySelectedSurah: _selectedSurah,
                              currentlySelectedAya: _selectedAyat,
                            ),

                            // audio controls
                            QuranAyatDisplayAudioControlsWidget(
                              currentlySelectedSurah: _selectedSurah,
                              currentlySelectedAya: _selectedAyat,
                              onAudioPlayStatusChanged:
                                  _onAudioPlayStatusChanged,
                              continuousMode: _isAudioContinuousModeEnabled,
                            ),

                            /// Notes
                            QuranAyatDisplayNotesWidget(
                              currentlySelectedSurah: _selectedSurah,
                              currentlySelectedAya: _selectedAyat,
                              continuousMode: _isAudioContinuousModeEnabled,
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _resetFontSize() {
    setState(() {
      QuranSettingsManager.instance.resetFontSize();
    });
  }

  void _incrementFontSize() {
    setState(() {
      QuranSettingsManager.instance.incrementFontSize();
    });
  }

  void _decrementFontSize() {
    setState(() {
      QuranSettingsManager.instance.decrementFontSize();
    });
  }

  void _navigateToBookmark(NQBookmark? bookmark) {
    if (_isInteractionAllowedOnScreen()) {
      if (_selectedSurah != null && bookmark != null && bookmark.ayat > 0) {
        setState(() {
          _selectedSurah = _surahTitles[bookmark.surah];
          _selectedAyat = bookmark.ayat;
        });
      }
    } else {
      _showMessage(QuranStrings.contPlayMessage);
    }
  }

  void _onBookmarkCleared(BuildContext context) {
    if (_isInteractionAllowedOnScreen()) {
      widget.bookmarksManager.localEngine.clear();
      widget.bookmarksManager.remoteEngine?.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("👍 Cleared ")),
      );
    } else {
      _showMessage(QuranStrings.contPlayMessage);
    }
  }

  Future<void> _onCopyToClipboardIconPressed(BuildContext context) async {
    int? surahIndex = _selectedSurah?.number;
    if (surahIndex != null) {
      String surahName = _surahTitles[surahIndex - 1].transliterationEn;
      int ayaIndex = _selectedAyat;
      String shareString = await QuranUtils.shareString(
        surahName,
        surahIndex,
        ayaIndex,
      );
      Clipboard.setData(ClipboardData(text: shareString)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Copied to clipboard 👍"),
          ),
        );
      });
      QuranLogger.logAnalytics("share");
    }
  }

  void _randomVersePressed() {
    try {
      int randomSurahIndex = Random().nextInt(114);
      int randomAyaIndex = Random().nextInt(
          _surahTitles[randomSurahIndex].totalVerses,) + 1;
      setState(() {
        _selectedSurah = _surahTitles[randomSurahIndex];
        _selectedAyat = randomAyaIndex;
      });
    } catch (_) {}
  }

  ///
  /// Bookmark
  ///
  void _saveBookmarkDialogAction() async {
    if (_selectedSurah != null) {
      // save locally
      int? surahIndex = _selectedSurah?.number;
      if (surahIndex != null) {
        // actual index starts from 0
        surahIndex = surahIndex - 1;
        // proceed with saving
        widget.bookmarksManager.localEngine.save(
          surahIndex,
          _selectedAyat,
        );
        // sync bookmark to cloud
        widget.bookmarksManager.remoteEngine?.save(
          surahIndex,
          _selectedAyat,
        );
        // show success message
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("👍 Saved ")));
      }
    }
  }

  void _authChangeListener() async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      /// upload local notes
      await QuranNotesManager.instance.uploadLocalNotesIfAny(user.uid);

      widget.bookmarksManager.remoteEngine ??= QuranFirebaseBookmarksEngine(
          userId: user.uid,
        );

      /// fetch bookmark
      NQBookmark? bookmark = await widget.bookmarksManager.remoteEngine?.fetch();
      if (bookmark != null) {
        widget.bookmarksManager.localEngine.save(
          bookmark.surah,
          bookmark.ayat,
        );

        /// displays the bookmark page if available on load
        // Load bookmark only if page loaded first time and not through links
        // TODO: Work around hack, change this logic later on
        if (_selectedAyat == 1 && _selectedSurah == _surahTitles.first) {
          _selectedAyat = bookmark.ayat;
          _selectedSurah = _surahTitles[bookmark.surah];
        }
      }
    }
    setState(() {});
  }

  void _handleUrlPathsForWeb() {
    if (kIsWeb) {
      String? searchString = _urlQuerySearchString;
      String? suraIndex = _urlQuerySuraIndex;
      String? ayaIndex = _urlQueryAyaIndex;
      if (searchString != null && searchString.isNotEmpty) {
        // we have a search url
        // navigate to search screen
        Future.delayed(
          const Duration(seconds: 1),
          () => {
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QuranSearchScreen(searchString: searchString),
              ),
            ),
          },
        );
        QuranLogger.logAnalytics("url-search");
      } else {
        // not a search url
        // check for surah/ayat format
        if (suraIndex != null &&
            ayaIndex != null &&
            suraIndex.isNotEmpty &&
            ayaIndex.isNotEmpty) {
          // have more than one
          // the last two paths should be surah/ayat format
          try {
            var selectedSurahIndex = int.parse(suraIndex) - 1;
            if (selectedSurahIndex >= 0 && selectedSurahIndex < 114) {
              _selectedSurah = _surahTitles[selectedSurahIndex];
              int totalVerses = _selectedSurah?.totalVerses ?? 0;
              var ayaIndexInt = int.parse(ayaIndex);
              if (_selectedSurah != null && ayaIndexInt <= totalVerses) {
                _selectedAyat = ayaIndexInt;
              } else {
                _selectedAyat = 1;
              }
            }
          } catch (_) {}
          QuranLogger.logAnalytics("url-sura-aya");
        } else if (suraIndex != null && suraIndex.isNotEmpty) {
          // has only one
          // the last path will be surah index
          try {
            var selectedSurahIndex = int.parse(suraIndex) - 1;
            if (selectedSurahIndex >= 0 && selectedSurahIndex < 114) {
              _selectedAyat = 1;
              _selectedSurah = _surahTitles[selectedSurahIndex];
            }
          } catch (_) {}
          QuranLogger.logAnalytics("url-aya");
        }
      }
    }
  }

  void _settingsChangedListener(String _) {
    setState(() {});
  }

  /// display next aya
  bool _moveToNextAyat() {
    int totalVerses = _selectedSurah?.totalVerses ?? 0;
    if (_selectedSurah != null) {
      int nextAyat = _selectedAyat + 1;
      if (nextAyat <= totalVerses) {
        setState(() {
          _selectedAyat = nextAyat;
        });
      } else {
        // end reached
        return false;
      }
    }

    return true;
  }

  /// display previous aya
  void _moveToPreviousAyat() {
    if (_selectedSurah != null) {
      int prevAyat = _selectedAyat - 1;
      if (prevAyat > 0) {
        setState(() {
          _selectedAyat = prevAyat;
        });
      }
    }
  }

  bool _isInteractionAllowedOnScreen() {
    // disable all interactions if continuous play mode is on
    return !_isAudioContinuousModeEnabled.value;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToContextListScreen() async {
    if(_selectedSurah != null) {
      int? selectedAyaIndex = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuranContextListScreen(
                title: _selectedSurah!.transliterationEn,
                surahIndex: _selectedSurah!.number-1,
                ayaIndex: _selectedAyat,),
        ),
      );

      if(selectedAyaIndex != null) {
        setState(() {
          _selectedAyat = selectedAyaIndex;
        });
      }

    }
  }

  ///
  /// Audio
  ///
  void _onAudioPlayStatusChanged(QuranAudioEventsEnum event) {
    switch (event) {
      case QuranAudioEventsEnum.stopped:
        _isAudioContinuousModeEnabled.value = false;
        break;

      case QuranAudioEventsEnum.loadNext:
        bool isNotEnded = _moveToNextAyat();
        if (!isNotEnded) {
          // sura completed - stop continuous play
          _isAudioContinuousModeEnabled.value = false;
        }
        break;

      case QuranAudioEventsEnum.contPlayStatusChanged:
        _isAudioContinuousModeEnabled.value =
            !_isAudioContinuousModeEnabled.value;
        break;

      default:
        break;
    }
  }
}
