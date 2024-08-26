import 'package:flutter/material.dart';

import '../../../../../misc/router/router_utils.dart';
import '../../../domain/models/quran_question.dart';
import 'quran_submission_answer_item_widget.dart';
import 'quran_title_with_background.dart';

class QuranSubmissionQuestionItemWidget extends StatelessWidget {
  final QuranQuestion question;

  const QuranSubmissionQuestionItemWidget({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),

        /// QUESTION
        QuranTitleWithBackground(title: question.title),

        const SizedBox(
          height: 15,
        ),

        /// ANSWERS LIST
        if (question.answers.isNotEmpty)
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: question.answers.length,
            shrinkWrap: true,
            separatorBuilder: (
              BuildContext context,
              int index,
            ) {
              return const Divider(
                thickness: 1,
              );
            },
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return ListTile(
                title: QuranSubmissionAnswerItemWidget(
                  answer: question.answers[index],
                ),
                onTap: () => QuranNavigator.of(context).routeToEditAnswer({
                  "questionId": question.id,
                  "answer": question.answers[index],
                }),
                trailing: const Icon(Icons.arrow_right),
              );
            },
          ),

        if (question.answers.isEmpty)
          const Center(child: Text("No submissions")),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
