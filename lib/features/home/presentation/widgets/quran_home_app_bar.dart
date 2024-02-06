import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../../../misc/configs/remote_config_manager.dart';
import '../../../../misc/router/router_utils.dart';
import '../../../bookmark/presentation/bookmark_icon_widget.dart';
import '../../../challenge/domain/redux/actions/actions.dart';
import '../../../challenge/presentation/widgets/answers/quran_reload_button_widget.dart';
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
        actions: [
          QuranReloadButtonWidget(
            action: () => _reloadQuestions(store),
          ),
          IconButton(
            onPressed: () => _help(context),
            icon: const Icon(
              Icons.question_mark,
            ),
          ),
        ],
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

  void _reloadQuestions(Store<AppState> store) {
    store.dispatch(InitializeChallengeScreenAction(questions: const []));
  }

  void _help(BuildContext context) {
    String message = RemoteConfigManager.instance.challengesHelpMessage;
    QuranNavigator.of(context).routeToMessage({
      'title': "Help",
      'message': message,
    });
  }
}
