import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../bookmark/data/bookmarks_local_impl.dart';
import '../../bookmark/domain/bookmarks_manager.dart';
import '../../bookmark/presentation/bookmark_icon_widget.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../drawer/presentation/nav_drawer.dart';
import '../../home/presentation/quran_home_screen.dart';
import '../../home/presentation/widgets/quran_home_bottom_sheet_widget.dart';
import '../data/surah_index.dart';
import '../domain/redux/actions/actions.dart';
import 'quran_new_ayat_widget.dart';

class QuranNewAyatScreen extends StatefulWidget {
  const QuranNewAyatScreen({Key? key}) : super(key: key);

  @override
  State<QuranNewAyatScreen> createState() => _QuranNewAyatScreenState();
}

class _QuranNewAyatScreenState extends State<QuranNewAyatScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      SurahIndex currentIndex = store.state.reader.currentIndex;

      if (store.state.reader.data.words.isEmpty) {
        // still loading
        return Container();
      }

      return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          bottom: true,
          child: Scaffold(
            drawer: QuranNavDrawer(
              user: store.state.user,
              bookmarksManager: QuranBookmarksManager(
                localEngine: QuranLocalBookmarksEngine(),
              ),
            ),
            // onDrawerChanged: null,
            bottomSheet: QuranHomeBottomSheetWidget(
              store: store,
              selectedTab: QuranHomeScreenBottomTabsEnum.reader,
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
        ),
      );
    });
  }
}
