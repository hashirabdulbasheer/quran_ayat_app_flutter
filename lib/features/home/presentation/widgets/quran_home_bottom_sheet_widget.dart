import 'package:flutter/material.dart';
import 'package:quran_ayat/features/challenge/domain/redux/actions/actions.dart';
import 'package:redux/redux.dart';

import '../../../../misc/design/design_system.dart';
import '../../../core/domain/app_state/app_state.dart';
import '../../../newAyat/domain/redux/actions/actions.dart';
import '../../../settings/domain/theme_manager.dart';
import '../quran_home_screen.dart';

class QuranHomeBottomSheetWidget extends StatelessWidget {
  final Store<AppState> store;
  final QuranHomeScreenBottomTabsEnum selectedTab;

  const QuranHomeBottomSheetWidget({
    Key? key,
    required this.store,
    required this.selectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nextTooltip = "Next aya";
    String previousTooltip = "Previous aya";

    if (selectedTab == QuranHomeScreenBottomTabsEnum.reader) {
      nextTooltip = "Next aya";
      previousTooltip = "Previous aya";
    } else {
      nextTooltip = "Next challenge";
      previousTooltip = "Previous challenge";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: previousTooltip,
                  child: ElevatedButton(
                    style: QuranDS.elevatedButtonStyle,
                    onPressed: () => _moveToPreviousAction(store),
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
                  message: nextTooltip,
                  child: ElevatedButton(
                    style: QuranDS.elevatedButtonStyle,
                    onPressed: () => _moveToNextAction(store),
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
    );
  }

  ///
  /// Theme
  ///

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

  void _moveToNextAction( Store<AppState> store, ) {
    if (selectedTab == QuranHomeScreenBottomTabsEnum.reader) {
      _moveToNextAyat(store);
    } else if (selectedTab == QuranHomeScreenBottomTabsEnum.challenge) {
      _moveToNextChallenge(store);
    }
  }

  void _moveToPreviousAction( Store<AppState> store, ) {
    if (selectedTab == QuranHomeScreenBottomTabsEnum.reader) {
      _moveToPreviousAyat(store);
    } else if (selectedTab == QuranHomeScreenBottomTabsEnum.challenge) {
      _moveToPreviousChallenge(store);
    }
  }

  /// display next aya
  void _moveToNextAyat(
    Store<AppState> store,
  ) {
    store.dispatch(NextAyaAction());
    if (store.state.reader.isHeaderVisible) {
      store.dispatch(ToggleHeaderVisibilityAction());
    }
  }

  /// display previous aya
  void _moveToPreviousAyat(
    Store<AppState> store,
  ) {
    store.dispatch(PreviousAyaAction());
    if (store.state.reader.isHeaderVisible) {
      store.dispatch(ToggleHeaderVisibilityAction());
    }
  }

  /// display next challenge
  void _moveToNextChallenge(
    Store<AppState> store,
  ) {
    store.dispatch(NextChallengeScreenAction());
  }

  /// display previous challenge
  void _moveToPreviousChallenge(
    Store<AppState> store,
  ) {
    store.dispatch(PreviousChallengeScreenAction());
  }
}
