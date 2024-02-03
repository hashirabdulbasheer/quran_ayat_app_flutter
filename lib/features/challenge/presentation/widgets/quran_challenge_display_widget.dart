import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../../misc/design/design_system.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      question.title,
                      textAlign: TextAlign.center,
                      style: QuranDS.textTitleMediumLight,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        question.question,
                        textAlign: TextAlign.start,
                        style: QuranDS.textTitleMediumLightSmallLineSpacing,
                      ),
                    ),
                  ],
                ),
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
      );
    });
  }
}
