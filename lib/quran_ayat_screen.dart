import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';

class QuranAyatScreen extends StatefulWidget {
  const QuranAyatScreen({Key? key}) : super(key: key);

  @override
  QuranAyatScreenState createState() => QuranAyatScreenState();
}

class QuranAyatScreenState extends State<QuranAyatScreen> {
  NQSurahTitle? _selectedSurah;
  int _selectedAyat = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quran Ayat"),
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
                return _body(snapshot.data as List<NQSurahTitle>);
              }
          }
        },
      ),
    );
  }

  Widget _body(List<NQSurahTitle> surahTitles) {
    _selectedSurah ??= surahTitles[0];
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// header
            _displayHeader(surahTitles),

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
                        return _ayatWidget(surahWords[_selectedAyat - 1]);
                      }
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
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
              mode: Mode.MENU,
              itemAsString: (surah) => "${surah?.number}) ${surah?.transliterationEn}",
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
        SizedBox(
          width: 10,
        ),
        _selectedSurah != null
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 80,
                    child: DropdownSearch<int>(
                      mode: Mode.MENU,
                      dropdownSearchDecoration:
                          const InputDecoration(labelText: "Ayat", hintText: "ayat index"),
                      showSearchBox: true,
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

  Widget _ayatWidget(List<NQWord> words) {
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
        .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            e.ar,
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                  ),
                  Text(
                    e.tr,
                    style: const TextStyle(color: Colors.black54, fontSize: 20),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ))
        .toList();
  }
}
