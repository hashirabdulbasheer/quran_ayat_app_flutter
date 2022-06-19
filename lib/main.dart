import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'quran_ayat_screen.dart';
import 'utils/search_utils.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// TODO: Update before release
const String appVersion = "v1.1.2";

void main() {
  runApp(const MyApp());
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
  _loadQuranWords();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Ayat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const QuranAyatScreen(),
    );
  }
}

/// load and save the quran words in memory
_loadQuranWords() async {
  QuranSearch.globalQRWords = [];
  for (var i = 0; i < 114; i++) {
    List<List<NQWord>> words = await NobleQuran.getSurahWordByWord(i);
    for (List<NQWord> aya in words) {
      QuranSearch.globalQRWords.addAll(aya);
    }
  }
}
