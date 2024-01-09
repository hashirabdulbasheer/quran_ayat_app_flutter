import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../../bookmark/presentation/bookmark_icon_widget.dart';
import '../../../core/domain/app_state/app_state.dart';
import '../../../newAyat/domain/redux/actions/actions.dart';
import '../quran_home_screen.dart';

class QuranHomeAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final Store<AppState> store;
  final QuranHomeScreenBottomTabsEnum selectedTab;

  const QuranHomeAppBarWidget({
    Key? key,
    required this.store,
    required this.selectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedTab == QuranHomeScreenBottomTabsEnum.challenge) {
      return AppBar(
        centerTitle: true,
        title: const Text("Quran"),
      );
    }

    return AppBar(
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
          currentIndex: store.state.reader.currentIndex,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
