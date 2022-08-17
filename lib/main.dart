import 'package:flutter/material.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'features/auth/domain/auth_factory.dart';
import 'features/notes/data/hive_notes_impl.dart';
import 'quran_ayat_screen.dart';
import 'utils/search_utils.dart';
import 'misc/url/url_strategy.dart';
import 'features/settings/domain/theme_manager.dart';

// TODO: Update before release
const String appVersion = "v2.1.9";

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await QuranHiveNotesEngine.instance.initialize();
  await QuranAuthFactory.engine.initialize();
  runApp(const MyApp());
  _loadQuranWords();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _appTheme = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemes();
    QuranThemeManager.instance.registerListener(onThemeChangedEvent);
  }

  @override
  void dispose() {
    QuranThemeManager.instance.removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran',
      debugShowCheckedModeBanner: false,
      theme: _appTheme == ThemeMode.light
          ? QuranThemeManager.instance.lightTheme
          : QuranThemeManager.instance.darkTheme,
      darkTheme: QuranThemeManager.instance.darkTheme,
      themeMode: _appTheme,
      home: const QuranAyatScreen(),
    );
  }

  void _loadThemes() async {
    _appTheme = await QuranThemeManager.instance.currentThemeMode();
    setState(() {});
  }

  /// callback when theme changes
  void onThemeChangedEvent(String? event) async {
    _loadThemes();
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
