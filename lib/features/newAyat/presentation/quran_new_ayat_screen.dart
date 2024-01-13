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

import '../../bookmark/data/bookmarks_local_impl.dart';
import '../../bookmark/presentation/bookmark_icon_widget.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../drawer/presentation/nav_drawer.dart';
import '../../settings/domain/theme_manager.dart';
import '../domain/redux/actions/actions.dart';
import 'quran_new_ayat_widget.dart';

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
          body: const QuranNewAyatReaderWidget(),
        ),
      );
    });
  }

  /// display next aya
  void _moveToNextAyat(
    Store<AppState> store,
  ) {
    store.dispatch(NextAyaAction());
  }

  /// display previous aya
  void _moveToPreviousAyat(
    Store<AppState> store,
  ) {
    store.dispatch(PreviousAyaAction());
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
}
