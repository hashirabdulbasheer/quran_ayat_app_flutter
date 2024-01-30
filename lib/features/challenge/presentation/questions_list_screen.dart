import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../core/domain/app_state/app_state.dart';
import '../domain/models/quran_question.dart';
import '../domain/redux/actions/actions.dart';
import 'quran_challenge_display_screen.dart';

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
                      trailing: const Icon(Icons.chevron_right_rounded),
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
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranChallengeDisplayScreen(store: store),
      ),
    ).then((value) {});
  }
}
