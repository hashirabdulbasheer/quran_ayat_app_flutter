import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/features/ayats/domain/enums/audio_events_enum.dart';
import 'features/auth/domain/auth_factory.dart';
import 'features/auth/presentation/quran_login_screen.dart';
import 'features/ayats/presentation/widgets/audio_row_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_header_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_surah_progress_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_translation_widget.dart';
import 'features/ayats/presentation/widgets/ayat_display_transliteration_widget.dart';
import 'features/bookmark/domain/bookmarks_manager.dart';
import 'features/bookmark/presentation/bookmark_icon_widget.dart';
import 'features/drawer/presentation/nav_drawer.dart';
import 'features/notes/domain/entities/quran_note.dart';
import 'features/notes/domain/notes_manager.dart';
import 'features/notes/presentation/quran_create_notes_screen.dart';
import 'features/notes/presentation/widgets/offline_header_widget.dart';
import 'features/settings/domain/settings_manager.dart';
import 'features/settings/domain/theme_manager.dart';
import 'misc/enums/quran_font_family_enum.dart';
import 'models/qr_user_model.dart';
import 'quran_search_screen.dart';
import 'utils/logger_utils.dart';
import 'utils/utils.dart';

class QuranAyatScreen extends StatefulWidget {
  final int? surahIndex;
  final int? ayaIndex;

  const QuranAyatScreen({
    Key? key,
    this.surahIndex,
    this.ayaIndex,
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

  final String _contPlayMessage =
      "Continuous Play in progress. Please stop first.";

  ///
  /// Theme
  ///

  ButtonStyle? get _elevatedButtonTheme {
    // if system dark mode is set then use dark mode buttons
    // else use gray button
    if (QuranThemeManager.instance.isDarkMode()) {
      return ElevatedButton.styleFrom(
        primary: Colors.white70,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(color: Colors.black),
      );
    }

    return ElevatedButton.styleFrom(
      primary: Colors.black12,
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
  }

  @override
  void dispose() {
    super.dispose();
    QuranAuthFactory.engine.unregisterAuthChangeListener(_authChangeListener);
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

    return Semantics(
      textDirection: TextDirection.rtl,
      enabled: true,
      container: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: widget.surahIndex == null
              ? QuranNavDrawer(user: QuranAuthFactory.engine.getUser())
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
                            {_showMessage(_contPlayMessage)},
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
                            {_showMessage(_contPlayMessage)},
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
              QuranBookmarkIconWidget(
                currentSurahIndex: surahIndex,
                currentAyaIndex: _selectedAyat,
                onSaveButtonPressed: () => {
                  if (_isInteractionAllowedOnScreen())
                    {_saveBookmarkDialogAction()}
                  else
                    {_showMessage(_contPlayMessage)},
                },
                onClearButtonPressed: () => _onBookmarkCleared(context),
                onGoToButtonPressed: (NQBookmark? bookmark) =>
                    _navigateToBookmark(bookmark),
              ),
            ],
          ),
          body: _surahTitles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _body(),
        ),
      ),
    );
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
      _showMessage(_contPlayMessage);
    }
  }

  void _onBookmarkCleared(BuildContext context) {
    if (_isInteractionAllowedOnScreen()) {
      QuranBookmarksManager.instance.clearLocal();
      QuranBookmarksManager.instance.clearRemote();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("👍 Cleared ")),
      );
    } else {
      _showMessage(_contPlayMessage);
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
    }
  }

  Widget _body() {
    _selectedSurah ??= _surahTitles[widget.surahIndex ?? 0];

    return SingleChildScrollView(
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

                const SizedBox(height: 25),

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
                            width: MediaQuery.of(context).size.width,
                            child: const Center(child: Text('Loading....')),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            List<List<NQWord>> surahWords =
                                snapshot.data as List<List<NQWord>>;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _ayaWidget(surahWords[_selectedAyat - 1]),
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
                _audioControlsWidget(),

                /// Notes
                _notesWidget(),

                const SizedBox(height: 30),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ayaWidget(List<NQWord> words) {
    return Semantics(
      enabled: true,
      excludeSemantics: false,
      label: "quran ayat display with meaning",
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.end,
                  children: _wordsWidgetList(words),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _wordsWidgetList(List<NQWord> words) {
    return words
        .map((e) => Semantics(
              enabled: true,
              excludeSemantics: true,
              container: true,
              child: Tooltip(
                message: '${e.ar} ${e.tr}',
                child: InkWell(
                  onTap: () => {
                    if (_isInteractionAllowedOnScreen())
                      {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuranSearchScreen(searchString: e.ar),
                          ),
                        ),
                      }
                    else
                      {_showMessage(_contPlayMessage)},
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            e.ar,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontFamily: QuranFontFamily.arabic.rawString,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.black26),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(1)),
                          ),
                          child: Text(
                            e.tr,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }

  Widget _notesWidget() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () => {
              if (_isInteractionAllowedOnScreen())
                {_goToLoginScreen()}
              else
                {_showMessage(_contPlayMessage)},
            },
            child: const Text("Login to add notes"),
          ),
        ),
      );
    }
    // logged in
    if (_selectedSurah == null) {
      return Container();
    }

    int? surahIndex = _selectedSurah?.number;

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const QuranOfflineHeaderWidget(),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.black12),
            ),
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.fromLTRB(
            10,
            0,
            10,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Notes"),
              ElevatedButton(
                onPressed: () => {
                  if (_isInteractionAllowedOnScreen())
                    {_goToCreateNoteScreen()}
                  else
                    {_showMessage(_contPlayMessage)},
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        surahIndex != null
            ? FutureBuilder<List<QuranNote>>(
                future: QuranNotesManager.instance.fetch(
                  user.uid,
                  surahIndex,
                  _selectedAyat,
                ),
                // async work
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<QuranNote>> snapshot,
                ) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100,
                          child: Center(child: Text('Loading notes....')),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        QuranLogger.log("Error notes: ${snapshot.error}");

                        return const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: SizedBox(
                            height: 50,
                            child: Text(
                              'Unable to load notes. Please check internet connectivity',
                              style: TextStyle(color: Colors.black38),
                            ),
                          ),
                        );
                      } else {
                        List<QuranNote> notes =
                            snapshot.data as List<QuranNote>;
                        if (notes.isNotEmpty) {
                          return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notes.length,
                            shrinkWrap: true,
                            separatorBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return const Divider(
                                thickness: 1,
                              );
                            },
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              TextDirection textDirection = TextDirection.ltr;
                              if (!QuranUtils.isEnglish(notes[index].note)) {
                                textDirection = TextDirection.rtl;
                              }

                              return Directionality(
                                textDirection: textDirection,
                                child: ListTile(
                                  onTap: () => {
                                    if (_isInteractionAllowedOnScreen())
                                      {
                                        _goToCreateNoteScreen(
                                          note: notes[index],
                                        ),
                                      }
                                    else
                                      {_showMessage(_contPlayMessage)},
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notes[index].note,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          QuranNotesManager.instance
                                              .formattedDate(
                                            notes[index].createdOn,
                                          ),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return TextButton(
                          onPressed: () => _goToCreateNoteScreen(),
                          child: const SizedBox(
                            height: 100,
                            child: Center(child: Text("Add Note")),
                          ),
                        );
                      }
                  }
                },
              )
            : Container(),
      ],
    );
  }

  Widget _audioControlsWidget() {
    return FutureBuilder<bool>(
      future: QuranSettingsManager.instance.isAudioControlsEnabled(),
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 80,
                child: Center(child: Text('Loading audio ....')),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Container();
            } else {
              bool isEnabled = snapshot.data as bool;
              if (isEnabled) {
                if (_selectedSurah == null) {
                  return Container();
                }

                return ValueListenableBuilder<bool>(
                  builder: (
                    BuildContext context,
                    bool isContinuousPlay,
                    Widget? child,
                  ) {
                    int? surahIndex = _selectedSurah?.number;
                    if (surahIndex != null) {
                      return QuranAudioRowWidget(
                        isAudioRecitationContinuousPlayEnabled:
                            isContinuousPlay,
                        surahIndex: surahIndex,
                        onAudioEventsListener: _onAudioPlayStatusChanged,
                        ayaIndex: _selectedAyat,
                      );
                    }

                    return Container();
                  },
                  valueListenable: _isAudioContinuousModeEnabled,
                );
              } else {
                return Container();
              }
            }
        }
      },
    );
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
        QuranBookmarksManager.instance.saveLocal(
          surahIndex,
          _selectedAyat,
        );
        // sync bookmark to cloud
        QuranBookmarksManager.instance.saveRemote(
          surahIndex,
          _selectedAyat,
        );
        // show success message
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("👍 Saved ")));
      }
    }
  }

  ///
  /// Actions
  ///

  void _goToLoginScreen() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const QuranLoginScreen()),
    ).then((value) {
      setState(() {});
    });
  }

  void _goToCreateNoteScreen({QuranNote? note}) {
    if (_selectedSurah != null) {
      int? surahIndex = _selectedSurah?.number;
      if (surahIndex != null) {
        Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (context) => QuranCreateNotesScreen(
              note: note,
              suraIndex: surahIndex,
              ayaIndex: _selectedAyat,
            ),
          ),
        ).then((value) {
          setState(() {});
        });
      }
    }
  }

  ///
  /// Utils
  ///

  /// special font handling for translations
  String? translationFontFamily(NQTranslation translation) {
    if (translation == NQTranslation.malayalam_karakunnu ||
        translation == NQTranslation.malayalam_abdulhameed) {
      return QuranFontFamily.malayalam.rawString;
    }

    return null;
  }

  void _authChangeListener() async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      /// upload local notes
      await QuranNotesManager.instance.uploadLocalNotesIfAny(user.uid);

      /// fetch bookmark
      NQBookmark? bookmark = await QuranBookmarksManager.instance.fetchRemote();
      if (bookmark != null) {
        QuranBookmarksManager.instance.saveLocal(
          bookmark.surah,
          bookmark.ayat,
        );
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
            int totalVerses = _selectedSurah?.totalVerses ?? 0;
            if (selectedSurahIndex >= 0 && selectedSurahIndex < 114) {
              _selectedSurah = _surahTitles[selectedSurahIndex];
              var ayaIndexInt = int.parse(ayaIndex);
              if (_selectedSurah != null && ayaIndexInt <= totalVerses) {
                _selectedAyat = ayaIndexInt;
              } else {
                _selectedAyat = 1;
              }
            }
          } catch (_) {}
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
