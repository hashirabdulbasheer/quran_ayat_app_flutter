import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/home/presentation/widgets/quran_home_content_body_widget.dart';
import 'package:redux/redux.dart';

import '../../bookmark/data/bookmarks_local_impl.dart';
import '../../bookmark/domain/bookmarks_manager.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../drawer/presentation/nav_drawer.dart';
import 'widgets/quran_home_app_bar.dart';
import 'widgets/quran_home_bottom_sheet_widget.dart';

enum QuranHomeScreenBottomTabsEnum { reader, challenge }

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({Key? key}) : super(key: key);

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  QuranHomeScreenBottomTabsEnum _selectedBottomTab =
      QuranHomeScreenBottomTabsEnum.reader;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          /// APP BAR
          appBar: QuranHomeAppBarWidget(
            store: store,
            selectedTab: _selectedBottomTab,
          ),

          /// DRAWER
          drawer: QuranNavDrawer(
            user: store.state.user,
            bookmarksManager: QuranBookmarksManager(
              localEngine: QuranLocalBookmarksEngine(),
            ),
          ),

          /// BOTTOM SHEET
          bottomSheet: QuranHomeBottomSheetWidget(
            store: store,
            selectedTab: _selectedBottomTab,
          ),

          /// BODY
          body: QuranHomeBodyContentWidget(
            store: store,
            selectedTab: _selectedBottomTab,
          ),

          /// BOTTOM TABS
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex:
                _selectedBottomTab == QuranHomeScreenBottomTabsEnum.reader
                    ? 0
                    : 1,
            selectedItemColor: Colors.primaries.first,
            onTap: (value) => setState(() {
              if (value == 0) {
                _selectedBottomTab = QuranHomeScreenBottomTabsEnum.reader;
              } else {
                _selectedBottomTab = QuranHomeScreenBottomTabsEnum.challenge;
              }
            }),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Reader',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Challenges',
              ),
            ],
          ),
        ),
      );
    });
  }
}
