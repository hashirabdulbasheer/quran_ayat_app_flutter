import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../../../misc/design/design_system.dart';
import '../../../challenge/domain/redux/actions/actions.dart';
import '../../../core/domain/app_state/app_state.dart';
import '../../../newAyat/domain/redux/actions/actions.dart';
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
    TextDirection textDirection = TextDirection.ltr;
    if (selectedTab == QuranHomeScreenBottomTabsEnum.reader) {
      nextTooltip = "Next aya";
      previousTooltip = "Previous aya";
      // reader buttons in RTL
      textDirection = TextDirection.rtl;
    } else {
      nextTooltip = "Next challenge";
      previousTooltip = "Previous challenge";
    }

    return Directionality(
      textDirection: textDirection,
      child: Container(
        color: QuranDS.screenBackground,
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
                      child: const Icon(
                        Icons.arrow_back,
                        color: QuranDS.primaryColor,
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
                      child: const Icon(
                        Icons.arrow_forward,
                        color: QuranDS.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _moveToNextAction(
    Store<AppState> store,
  ) {
    if (selectedTab == QuranHomeScreenBottomTabsEnum.reader) {
      _moveToNextAyat(store);
    } else if (selectedTab == QuranHomeScreenBottomTabsEnum.challenge) {
      _moveToNextChallenge(store);
    }
  }

  void _moveToPreviousAction(
    Store<AppState> store,
  ) {
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
