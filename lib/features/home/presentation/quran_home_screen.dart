import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../utils/logger_utils.dart';
import '../../bookmark/data/bookmarks_local_impl.dart';
import '../../bookmark/domain/bookmarks_manager.dart';
import '../../challenge/domain/redux/actions/actions.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../drawer/presentation/nav_drawer.dart';
import 'widgets/quran_home_app_bar.dart';
import 'widgets/quran_home_bottom_sheet_widget.dart';
import 'widgets/quran_home_content_body_widget.dart';

enum QuranHomeScreenBottomTabsEnum { reader, challenge }

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({Key? key}) : super(key: key);

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      return SafeArea(
        bottom: true,
        child: Scaffold(
          /// APP BAR
          appBar: QuranHomeAppBarWidget(
            store: store,
            selectedTab: store.state.challenge.selectedHomeScreenTab,
          ),

          /// DRAWER
          drawer: QuranNavDrawer(
            user: store.state.user,
            bookmarksManager: QuranBookmarksManager(
              localEngine: QuranLocalBookmarksEngine(),
            ),
          ),

          /// BOTTOM SHEET
          bottomSheet: store.state.challenge.selectedHomeScreenTab ==
                  QuranHomeScreenBottomTabsEnum.reader
              ? QuranHomeBottomSheetWidget(
                  store: store,
                  selectedTab: store.state.challenge.selectedHomeScreenTab,
                )
              : null,

          /// BODY
          body: QuranHomeBodyContentWidget(
            store: store,
            selectedTab: store.state.challenge.selectedHomeScreenTab,
          ),

          /// BOTTOM TABS
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: store.state.challenge.selectedHomeScreenTab ==
                    QuranHomeScreenBottomTabsEnum.reader
                ? 0
                : 1,
            selectedItemColor: Colors.blueGrey,
            unselectedItemColor: Colors.black38,
            onTap: (value) => setState(() {
              if (value == 0) {
                store.dispatch(
                  SelectHomeScreenTabAction(
                    tab: QuranHomeScreenBottomTabsEnum.reader,
                  ),
                );
                QuranLogger.logAnalytics("tab-reader");
              } else {
                store.dispatch(
                  SelectHomeScreenTabAction(
                    tab: QuranHomeScreenBottomTabsEnum.challenge,
                  ),
                );
                QuranLogger.logAnalytics("tab-challenge");
              }
            }),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book_rounded,
                  size: 20,
                ),
                label: 'Read',
                tooltip: 'Read',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.assignment_outlined,
                  size: 20,
                ),
                label: 'Challenge',
                tooltip: 'Challenge',
              ),
            ],
          ),
        ),
      );
    });
  }
}
