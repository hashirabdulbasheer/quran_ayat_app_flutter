import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../core/domain/app_state/app_state.dart';
import '../../domain/models/quran_question.dart';
import 'answers/quran_answers_widget.dart';

class QuranChallengeDisplayWidget extends StatelessWidget {
  const QuranChallengeDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      QuranQuestion? question =
          store.state.challenge.currentQuestionForDisplay();
      if (question == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      question.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        question.question,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                QuranAnswersWidget(
                  question: question,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
