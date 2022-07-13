import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/features/auth/data/firebase_auth_impl.dart';
import 'package:quran_ayat/features/auth/domain/auth_factory.dart';
import 'package:quran_ayat/features/notes/data/firebase_notes_impl.dart';
import 'package:quran_ayat/features/notes/data/hive_notes_impl.dart';
import 'package:quran_ayat/features/notes/domain/notes_factory.dart';
import 'quran_ayat_screen.dart';
import 'utils/search_utils.dart';
import 'misc/url/url_strategy.dart';

// TODO: Update before release
const String appVersion = "v2.0.0";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await QuranHiveNotesEngine.instance.initialize();
  await QuranAuthFactory.engine.initialize();
  runApp(const MyApp());
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
