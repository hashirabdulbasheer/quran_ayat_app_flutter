import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/bookmark.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/utils/prefs_utils.dart';
import 'package:quran_ayat/utils/utils.dart';

import 'main.dart';
import 'quran_search_screen.dart';

class QuranAyatScreen extends StatefulWidget {
  final int? surahIndex;
  final int? ayaIndex;

  const QuranAyatScreen({Key? key, this.surahIndex, this.ayaIndex}) : super(key: key);

  @override
  QuranAyatScreenState createState() => QuranAyatScreenState();
}

class QuranAyatScreenState extends State<QuranAyatScreen> {
  List<NQSurahTitle> _surahTitles = [];
  NQSurahTitle? _selectedSurah;
  int _selectedAyat = 1;
  NQBookmark? _currentBookmark;

  @override
  void initState() {
    super.initState();
    _selectedAyat = widget.ayaIndex ?? 1;
    QuranPreferences.getBookmark().then((bookmark) {
      _currentBookmark = bookmark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
                            textStyle:
                                const TextStyle(color: Colors.deepPurple) // This is what you need!
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
                            shadowColor: Colors.transparent // This is what you need!
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
                        child: const Icon(Icons.arrow_forward, color: Colors.deepPurple)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(appVersion, style: TextStyle(fontSize: 10),),
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Quran Ayat"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuranSearchScreen()),
                  );
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _showBookmarkAlertDialog();
                },
                icon: _isThisBookmarkedAya()
                    ? const Icon(Icons.bookmark)
                    : const Icon(Icons.bookmark_border_outlined)),
          ],
        ),
        body: FutureBuilder<List<NQSurahTitle>>(
          future: NobleQuran.getSurahList(), // async work
          builder: (BuildContext context, AsyncSnapshot<List<NQSurahTitle>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Padding(padding: EdgeInsets.all(8.0), child: Text('Loading....'));
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  _surahTitles = snapshot.data as List<NQSurahTitle>;
                  return _body(_surahTitles);
                }
            }
          },
        ),
      ),
    );
  }

  Widget _body(List<NQSurahTitle> surahTitles) {
    int actualSurahIndex = widget.surahIndex != null ? widget.surahIndex! - 1 : 0;
    _selectedSurah ??= surahTitles[actualSurahIndex];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// header
                _displayHeader(surahTitles),

                const SizedBox(height: 10),

                /// body
                Card(
                  elevation: 5,
                  child: FutureBuilder<List<List<NQWord>>>(
                    future: NobleQuran.getSurahWordByWord((_selectedSurah?.number ?? 1) - 1),
                    // async work
                    builder: (BuildContext context, AsyncSnapshot<List<List<NQWord>>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Padding(
                              padding: EdgeInsets.all(8.0), child: Text('Loading....'));
                        default:
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<List<NQWord>> surahWords = snapshot.data as List<List<NQWord>>;
                            return _ayaWidget(surahWords[_selectedAyat - 1]);
                          }
                      }
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayHeader(List<NQSurahTitle> surahTitles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 80,
            child: DropdownSearch<NQSurahTitle>(
              items: surahTitles,
              popupProps: const PopupPropsMultiSelection.menu(),
              itemAsString: (surah) => "${surah.number}) ${surah.transliterationEn}",
              dropdownSearchDecoration:
                  const InputDecoration(labelText: "Surah", hintText: "select surah"),
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
        const SizedBox(width: 10),
        _selectedSurah != null
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: SizedBox(
                    width: 100,
                    height: 80,
                    child: DropdownSearch<int>(
                      popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
                      filterFn: (item, filter) {
                        if (filter.isEmpty) {
                          return true;
                        }
                        if ("$item" == QuranUtils.replaceFarsiNumber(filter)) {
                          return true;
                        }
                        return false;
                      },
                      dropdownSearchDecoration:
                          const InputDecoration(labelText: "Ayat", hintText: "ayat index"),
                      items: List<int>.generate(_selectedSurah?.totalVerses ?? 0, (i) => i + 1),
                      onChanged: (value) {
                        setState(() {
                          _selectedAyat = value ?? 1;
                        });
                      },
                      selectedItem: _selectedAyat,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _ayaWidget(List<NQWord> words) {
    return Directionality(
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
                runSpacing: 10,
                spacing: 5,
                children: _wordsWidgetList(words),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _wordsWidgetList(List<NQWord> words) {
    return words
        .map((e) => InkWell(
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 120,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              e.ar,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 40, fontFamily: "Alvi"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.tr,
                      style: const TextStyle(color: Colors.black54, fontSize: 20),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }

  ///
  /// Bookmark
  ///
  void _showFirstTimeBookmarkAlertDialog() {
    AlertDialog alert;

    // no bookmark saved
    Widget okButton = TextButton(
      child: const Text("Save"),
      onPressed: () {
        if (_selectedSurah != null) {
          QuranPreferences.saveBookmark(_selectedSurah!.number - 1, _selectedAyat);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("👍 Saved ")));
          Navigator.of(context).pop();
        }
      },
    );

    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.black45),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    alert = AlertDialog(
      content: const Text("Do you want to bookmark this aya?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showMultipleOptionTimeBookmarkAlertDialog(NQBookmark bookmark) {
    AlertDialog alert;
    Widget saveButton = TextButton(
      child: const Text("Save bookmark", style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () {
        if (_selectedSurah != null) {
          QuranPreferences.saveBookmark(_selectedSurah!.number - 1, _selectedAyat);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("👍 Saved ")));
          Navigator.of(context).pop();
        }
      },
    );

    Widget clearButton = TextButton(
      child: const Text("Clear bookmark", style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () {
        if (_selectedSurah != null) {
          QuranPreferences.saveBookmark(0, 0);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("👍 Cleared ")));
        }
        Navigator.of(context).pop();
      },
    );

    Widget displayButton = TextButton(
      child: const Text("Go to bookmark", style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () {
        if (_selectedSurah != null && bookmark.ayat > 0) {
          setState(() {
            _selectedSurah = _surahTitles[bookmark.surah];
            _selectedAyat = bookmark.ayat;
          });
        }
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.black45),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    alert = AlertDialog(
      content: const Text("What would you like to do?"),
      actions: [saveButton, displayButton, clearButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showBookmarkAlertDialog() async {
    NQBookmark? currentBookmark = await QuranPreferences.getBookmark();
    if (currentBookmark == null) {
      // no bookmark saved
      _showFirstTimeBookmarkAlertDialog();
    } else {
      // there is a previous bookmark
      _showMultipleOptionTimeBookmarkAlertDialog(currentBookmark);
    }
  }

  bool _isThisBookmarkedAya() {
    if (_selectedSurah != null && _currentBookmark != null) {
      int currentSurahIndex = _selectedSurah!.number - 1;
      int currentAyaIndex = _selectedAyat;
      if (currentSurahIndex == _currentBookmark?.surah &&
          currentAyaIndex == _currentBookmark?.ayat) {
        return true;
      }
    }
    return false;
  }
}
