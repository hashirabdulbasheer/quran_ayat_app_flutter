import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../../challenge/presentation/questions_list_screen.dart';
import '../../../core/domain/app_state/app_state.dart';
import '../../../newAyat/presentation/quran_new_ayat_widget.dart';
import '../quran_home_screen.dart';

class QuranHomeBodyContentWidget extends StatelessWidget {
  final Store<AppState> store;
  final QuranHomeScreenBottomTabsEnum selectedTab;

  const QuranHomeBodyContentWidget({
    Key? key,
    required this.store,
    required this.selectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedTab == QuranHomeScreenBottomTabsEnum.reader) {
      /// reader screen
      return const QuranNewAyatReaderWidget();
    } else if (selectedTab == QuranHomeScreenBottomTabsEnum.challenge) {
      /// challenge screen
      return const Directionality(
        textDirection: TextDirection.ltr,
        child: QuranQuestionsListScreen(),
      );
    }

    return Container();
  }
}
