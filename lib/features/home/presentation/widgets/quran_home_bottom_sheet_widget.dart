import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

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
    if (selectedTab == QuranHomeScreenBottomTabsEnum.reader) {
      return Padding(
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
      );
    }

    return Container();
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

  /// display next aya
  void _moveToNextAyat(
    Store<AppState> store,
  ) {
    store.dispatch(NextAyaAction());
    // _closeHeader();
  }

  /// display previous aya
  void _moveToPreviousAyat(
    Store<AppState> store,
  ) {
    store.dispatch(PreviousAyaAction());
    // _closeHeader();
  }
}
