import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/models/qr_user_model.dart';
import 'package:redux/redux.dart';

import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../domain/models/quran_question.dart';
import '../domain/redux/actions/actions.dart';
import 'widgets/answers/quran_reload_button_widget.dart';
import 'widgets/submissions/quran_submission_question_item_widget.dart';

class QuranMyChallengeSubmissionsScreen extends StatelessWidget {
  const QuranMyChallengeSubmissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      return const Center(child: Text('No submissions'));
    }

    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      List<QuranQuestion> questions =
          store.state.challenge.userSubmittedQuestions(user);

      return Scaffold(
        /// APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Submissions"),
          actions: [
            QuranReloadButtonWidget(action: () => _reloadQuestions(store)),
          ],
        ),

        /// BODY
        body: questions.isEmpty
            ? const Center(child: Text("No submissions"))
            : SingleChildScrollView(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                shrinkWrap: true,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return QuranSubmissionQuestionItemWidget(
                    question: questions[index],
                  );
                },
              ),
            ),
      );
    });
  }

  void _reloadQuestions(Store<AppState> store) {
    store.dispatch(InitializeChallengeScreenAction(questions: const []));
  }
}
