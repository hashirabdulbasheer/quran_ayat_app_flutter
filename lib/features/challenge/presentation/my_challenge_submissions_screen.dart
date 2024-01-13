import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/challenge/domain/redux/actions/actions.dart';
import 'package:quran_ayat/models/qr_user_model.dart';
import 'package:redux/redux.dart';

import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../domain/challenge_manager.dart';
import '../domain/models/quran_question.dart';
import 'widgets/submissions/quran_submission_question_item_widget.dart';

class MyChallengeSubmissionsScreen extends StatelessWidget {
  const MyChallengeSubmissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuranUser? user = QuranAuthFactory.engine.getUser();

    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          /// APP BAR
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Submissions"),
            actions: [
              IconButton(
                onPressed: () => _reloadQuestions(store),
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
              ),
            ],
          ),

          /// BODY
          body: user == null
              ? const Center(child: Text('No submissions'))
              : Directionality(
                  textDirection: TextDirection.ltr,
                  child: FutureBuilder<List<QuranQuestion>>(
                    future: QuranChallengeManager.instance
                        .fetchQuestionsWithUserSubmissions(user),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<QuranQuestion>> snapshot,
                    ) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          List<QuranQuestion> questions = snapshot.data ?? [];
                          if (snapshot.hasError || questions.isEmpty) {
                            return const Center(child: Text('No submissions'));
                          } else {
                            return SingleChildScrollView(
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
                            );
                          }
                      }
                    },
                  ),
                ),
        ),
      );
    });
  }

  void _reloadQuestions(Store<AppState> store) {
     store.dispatch(ToggleLoadingScreenAction());
  }

}
