import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/features/bookmark/domain/bookmarks_manager.dart';
import 'features/auth/domain/auth_factory.dart';
import 'features/auth/presentation/quran_login_screen.dart';
import 'features/auth/presentation/quran_profile_screen.dart';
import 'features/bookmark/presentation/bookmark_icon_widget.dart';
import 'features/notes/domain/entities/quran_note.dart';
import 'features/notes/domain/notes_manager.dart';
import 'features/notes/presentation/quran_create_notes_screen.dart';
import 'features/notes/presentation/widgets/offline_header_widget.dart';
import 'main.dart';
import 'models/qr_user_model.dart';
import 'quran_search_screen.dart';
import 'utils/utils.dart';
import 'package:intl/intl.dart' as intl;

class QuranAyatScreen extends StatefulWidget {
  final int? surahIndex;
  final int? ayaIndex;

  const QuranAyatScreen({Key? key, this.surahIndex, this.ayaIndex})
      : super(key: key);

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
  }

  @override
  void dispose() {
    super.dispose();
    QuranAuthFactory.engine.unregisterAuthChangeListener(_authChangeListener);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textDirection: TextDirection.rtl,
      enabled: true,
      container: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black12,
                                shadowColor: Colors.transparent,
                                textStyle: const TextStyle(
                                    color: Colors
                                        .deepPurple) // This is what you need!
                                ),
                            onPressed: () {
                              if (_selectedSurah != null) {
                                int prevAyat = _selectedAyat - 1;
                                if (prevAyat > 0) {
                                  setState(() {
                                    _selectedAyat = prevAyat;
                                  });
                                }
                              }
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.deepPurple,
                            )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black12,
                                shadowColor:
                                    Colors.transparent // This is what you need!
                                ),
                            onPressed: () {
                              if (_selectedSurah != null) {
                                int nextAyat = _selectedAyat + 1;
                                if (nextAyat <= _selectedSurah!.totalVerses) {
                                  setState(() {
                                    _selectedAyat = nextAyat;
                                  });
                                }
                              }
                            },
                            child: const Icon(Icons.arrow_forward,
                                color: Colors.deepPurple)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                          "$appVersion uxQuran",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Quran Ayat"),
              actions: [
                IconButton(
                    tooltip: "go to search screen",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuranSearchScreen()),
                      );
                    },
                    icon: const Icon(Icons.search)),
                QuranBookmarkIconWidget(
                    currentSurahIndex:
                        _selectedSurah != null ? _selectedSurah!.number - 1 : 0,
                    currentAyaIndex: _selectedAyat,
                    onSaveButtonPressed: () {
                      _saveBookmarkDialogAction();
                    },
                    onGoToButtonPressed: (NQBookmark? bookmark) {
                      if (_selectedSurah != null &&
                          bookmark != null &&
                          bookmark.ayat > 0) {
                        setState(() {
                          _selectedSurah = _surahTitles[bookmark.surah];
                          _selectedAyat = bookmark.ayat;
                        });
                      }
                    }),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: _profileIconBasedOnLoggedInStatus())
              ],
            ),
            body: _surahTitles.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _body()),
      ),
    );
  }

  Widget _body() {
    _selectedSurah ??= _surahTitles[widget.surahIndex ?? 0];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// header
                _displayHeader(),

                _progressInSurah(),

                const SizedBox(height: 25),

                /// body
                Card(
                  elevation: 5,
                  child: FutureBuilder<List<List<NQWord>>>(
                    future: NobleQuran.getSurahWordByWord(
                        (_selectedSurah?.number ?? 1) - 1),
                    // async work
                    builder: (BuildContext context,
                        AsyncSnapshot<List<List<NQWord>>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Loading....'));
                        default:
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
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

                // TODO: Hiding full arabic widget for now
                // const SizedBox(height: 20),
                // _fullArabicWidget(),

                const SizedBox(height: 20),

                _fullTranslationWidget(),

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

  Widget _displayHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: Semantics(
            enabled: true,
            excludeSemantics: true,
            label: 'dropdown to select surah',
            child: SizedBox(
              height: 80,
              child: DropdownSearch<NQSurahTitle>(
                items: _surahTitles,
                popupProps: const PopupPropsMultiSelection.menu(),
                itemAsString: (surah) =>
                    "(${surah.number}) ${surah.transliterationEn}",
                dropdownSearchDecoration: const InputDecoration(
                    labelText: "Surah", hintText: "select surah"),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedSurah = value;
                      _selectedAyat = 1;
                    }
                  });
                },
                selectedItem: _selectedSurah,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _selectedSurah != null
            ? Expanded(
                child: Semantics(
                  enabled: true,
                  excludeSemantics: true,
                  label: 'dropdown to select ayat number',
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: SizedBox(
                      width: 100,
                      height: 80,
                      child: DropdownSearch<int>(
                        popupProps: const PopupPropsMultiSelection.menu(
                            showSearchBox: true),
                        filterFn: (item, filter) {
                          if (filter.isEmpty) {
                            return true;
                          }
                          if ("$item" ==
                              QuranUtils.replaceFarsiNumber(filter)) {
                            return true;
                          }
                          return false;
                        },
                        dropdownSearchDecoration: const InputDecoration(
                            labelText: "Ayat", hintText: "ayat index"),
                        items: List<int>.generate(
                            _selectedSurah?.totalVerses ?? 0, (i) => i + 1),
                        onChanged: (value) {
                          setState(() {
                            _selectedAyat = value ?? 1;
                          });
                        },
                        selectedItem: _selectedAyat,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuranSearchScreen(
                                searchString: e.ar,
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontFamily: "Alvi"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1))),
                          child: Text(
                            e.tr,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontFamily: "default"),
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

  Widget _fullTranslationWidget() {
    return FutureBuilder<NQSurah>(
      future: NobleQuran.getTranslationString(
          _selectedSurah!.number - 1, NQTranslation.CLEAR),
      builder: (BuildContext context, AsyncSnapshot<NQSurah> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 100,
                    child: Center(child: Text('Loading translation....'))));
          default:
            if (snapshot.hasError) {
              return Container();
            } else {
              NQSurah surah = snapshot.data as NQSurah;
              List<NQAyat> ayats = surah.aya;
              return Card(
                elevation: 5,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            ayats[_selectedAyat - 1].text,
                            style: const TextStyle(
                                fontFamily: "default",
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        }
      },
    );
  }

  Widget _fullArabicWidget() {
    return FutureBuilder<NQSurah>(
      future: NobleQuran.getSurahArabic(_selectedSurah!.number - 1),
      builder: (BuildContext context, AsyncSnapshot<NQSurah> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 100,
                    child: Center(child: Text('Loading arabic verse....'))));
          default:
            if (snapshot.hasError) {
              return Container();
            } else {
              NQSurah surah = snapshot.data as NQSurah;
              List<NQAyat> ayats = surah.aya;
              return Card(
                elevation: 5,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            ayats[_selectedAyat - 1].text,
                            style: const TextStyle(
                                fontFamily: "Alvi",
                                fontSize: 35,
                                height: 1.5,
                                color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        }
      },
    );
  }

  Widget _notesWidget() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
              onPressed: () {
                _goToLoginScreen();
              },
              child: const Text("Login to add notes")),
        ),
      );
    }
    // logged in
    if (_selectedSurah == null) {
      return Container();
    }

    return FutureBuilder<List<QuranNote>>(
      future: QuranNotesManager.instance
          .fetch(user.uid, _selectedSurah!.number, _selectedAyat),
      // async work
      builder: (BuildContext context, AsyncSnapshot<List<QuranNote>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 100,
                    child: Center(child: Text('Loading notes....'))));
          default:
            if (snapshot.hasError) {
              print("Error notes: ${snapshot.error}");
              return const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
                    height: 50,
                    child: Text(
                      'Unable to load notes. Please check internet connectivity',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ));
            } else {
              List<QuranNote> notes = snapshot.data as List<QuranNote>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        color: Colors.black12,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Notes",
                          style: TextStyle(fontFamily: "default"),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _goToCreateNoteScreen();
                            },
                            child: const Text("Add",
                                style: TextStyle(fontFamily: "default")))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  notes.isNotEmpty
                      ? ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notes.length,
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              thickness: 1,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Directionality(
                              textDirection:
                                  QuranUtils.isEnglish(notes[index].note)
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                              child: ListTile(
                                  onTap: () {
                                    _goToCreateNoteScreen(note: notes[index]);
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(notes[index].note,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "default",
                                                color: Colors.black87)),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            "${_formattedDate(notes[index].createdOn)}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54)),
                                      ],
                                    ),
                                  )),
                            );
                          })
                      : TextButton(
                          onPressed: () {
                            _goToCreateNoteScreen();
                          },
                          child: const SizedBox(
                              height: 100,
                              child: Center(
                                  child: Text(
                                "Add Note",
                                style: TextStyle(fontFamily: "default"),
                              )))),
                ],
              );
            }
        }
      },
    );
  }

  Widget _profileIconBasedOnLoggedInStatus() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      return _profileIcon(icon: Icons.account_circle);
    }
    return _profileIcon(icon: Icons.account_circle_outlined);
  }

  _profileIcon({required IconData icon}) {
    return IconButton(
        tooltip: "user account",
        onPressed: () {
          _accountButtonTapped();
        },
        icon: Icon(icon, size: 30));
  }

  Widget _progressInSurah() {
    NQSurahTitle? surah = _selectedSurah;
    if (surah != null) {
      int totalAyas = surah.totalVerses;
      int currentAya = _selectedAyat;
      double progress = currentAya / totalAyas;
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: LinearProgressIndicator(
            backgroundColor: Colors.black12, value: progress),
      );
    }
    return Container();
  }

  ///
  /// Bookmark
  ///
  void _saveBookmarkDialogAction() async {
    if (_selectedSurah != null) {
      // save locally
      QuranBookmarksManager.instance
          .saveLocal(_selectedSurah!.number - 1, _selectedAyat);
      // sync bookmark to cloud
      QuranBookmarksManager.instance
          .saveRemote(_selectedSurah!.number - 1, _selectedAyat);
      // show success message
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("👍 Saved ")));
    }
  }

  ///
  /// Actions
  ///
  void _accountButtonTapped() async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      // not previously logged in, go to login
      _goToLoginScreen();
    } else {
      // already logged in
      _goToProfileScreen(user);
    }
  }

  _goToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuranLoginScreen()),
    ).then((value) {
      setState(() {});
    });
  }

  _goToCreateNoteScreen({QuranNote? note}) {
    if (_selectedSurah != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QuranCreateNotesScreen(
                  note: note,
                  suraIndex: _selectedSurah!.number,
                  ayaIndex: _selectedAyat,
                )),
      ).then((value) {
        setState(() {});
      });
    }
  }

  _goToProfileScreen(QuranUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuranProfileScreen(user: user)),
    ).then((value) {
      setState(() {});
    });
  }

  ///
  /// Utils
  ///

  _formattedDate(int timeMs) {
    DateTime now = DateTime.now();
    DateTime justNow = DateTime.now().subtract(const Duration(minutes: 1));
    var millis = DateTime.fromMillisecondsSinceEpoch(timeMs);
    if (!millis.difference(justNow).isNegative) {
      return 'Just now';
    }
    if (millis.day == now.day &&
        millis.month == now.month &&
        millis.year == now.year) {
      return intl.DateFormat('jm').format(now);
    }
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (millis.day == yesterday.day &&
        millis.month == yesterday.month &&
        millis.year == yesterday.year) {
      return 'Yesterday, ${intl.DateFormat('jm').format(now)}';
    }
    if (now.difference(millis).inDays < 4) {
      String weekday = intl.DateFormat('EEEE').format(millis);
      return '$weekday, ${intl.DateFormat('jm').format(now)}';
    }
    var d24 = intl.DateFormat('dd/MM/yyyy HH:mm').format(millis);
    return d24;
  }

  _authChangeListener() async {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user != null) {
      /// upload local notes
      await QuranNotesManager.instance.uploadLocalNotesIfAny(user.uid);

      /// fetch bookmark
      NQBookmark? bookmark = await QuranBookmarksManager.instance.fetchRemote();
      if (bookmark != null) {
        QuranBookmarksManager.instance.saveLocal(bookmark.surah, bookmark.ayat);
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
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QuranSearchScreen(searchString: searchString)),
          );
        });
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
            _selectedAyat = int.parse(ayaIndex);
            var selectedSurahIndex = int.parse(suraIndex) - 1;
            _selectedSurah = _surahTitles[selectedSurahIndex];
          } catch (_) {}
        } else if (suraIndex != null && suraIndex.isNotEmpty) {
          // has only one
          // the last path will be surah index
          try {
            _selectedAyat = 1;
            var selectedSurahIndex = int.parse(suraIndex) - 1;
            _selectedSurah = _surahTitles[selectedSurahIndex];
          } catch (_) {}
        }
      }
    }
  }
}
