import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../core/domain/app_state/app_state.dart';
import '../../home/presentation/widgets/quran_home_bottom_sheet_widget.dart';
import 'widgets/quran_challenge_display_widget.dart';

class QuranChallengeDisplayScreen extends StatelessWidget {
  final Store<AppState> store;

  const QuranChallengeDisplayScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            store.state.challenge.currentQuestionForDisplay()?.title ?? "",
          ),
        ),
        body: const QuranChallengeDisplayWidget(),
        bottomSheet: QuranHomeBottomSheetWidget(
          store: store,
          selectedTab: store.state.challenge.selectedHomeScreenTab,
        ),
      );
    });
  }
}
