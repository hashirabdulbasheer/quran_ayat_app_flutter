import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/misc/router/router_utils.dart';
import 'package:redux/redux.dart';

import '../../../utils/logger_utils.dart';
import '../../core/domain/app_state/app_state.dart';
import '../domain/models/quran_question.dart';
import '../domain/redux/actions/actions.dart';

class QuranQuestionsListScreen extends StatelessWidget {
  const QuranQuestionsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      List<QuranQuestion> questions = store.state.challenge.allQuestions;
      if (questions.isEmpty) {
        return const Center(child: Text("No questions yet!"));
      }

      return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.black26,
                    child: const Text(
                      "Questions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index].title,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(questions[index].question),
                        ],
                      ),
                      trailing: IntrinsicWidth(
                        child: Row(
                          children: [
                            if (store.state.challenge
                                .approvedAnswersForQuestion(questions[index])
                                .isNotEmpty)
                              Text(
                                "${store.state.challenge.approvedAnswersForQuestion(questions[index]).length}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                      onTap: () => _onQuestionTapped(
                        store,
                        context,
                        questions[index].id,
                      ),
                    );
                  },
                  separatorBuilder: (
                    context,
                    index,
                  ) =>
                      const Divider(),
                  itemCount: questions.length,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _onQuestionTapped(
    Store<AppState> store,
    BuildContext context,
    int questionId,
  ) {
    store.dispatch(
      SelectCurrentQuestionAction(questionId: questionId),
    );
    QuranNavigator.of(context).routeToChallenge(store);
    QuranLogger.logAnalyticsWithParams(
      "question-tap",
      {"questionId": questionId},
    );
  }
}
