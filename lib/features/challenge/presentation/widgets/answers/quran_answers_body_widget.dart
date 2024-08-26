import 'package:flutter/material.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../domain/models/quran_answer.dart';
import '../../../domain/models/quran_question.dart';
import 'quran_answers_list_widget.dart';

class QuranAnswerBodyWidget extends StatefulWidget {
  final QuranUser? user;
  final QuranQuestion? question;
  final Function onSubmitTapped;

  const QuranAnswerBodyWidget({
    super.key,
    required this.user,
    required this.question,
    required this.onSubmitTapped,
  });

  @override
  State<QuranAnswerBodyWidget> createState() => _QuranAnswerBodyWidgetState();
}

class _QuranAnswerBodyWidgetState extends State<QuranAnswerBodyWidget> {
  @override
  Widget build(BuildContext context) {
    List<QuranAnswer> answers = widget.question?.answers ?? [];
    // sort based on date to show latest first
    answers.sort((
      a,
      b,
    ) =>
        b.createdOn.compareTo(a.createdOn));
    // sort based on liked to show the most liked one first
    answers.sort((
      a,
      b,
    ) =>
        b.likedUsers.length.compareTo(a.likedUsers.length));
    if (answers.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: QuranAnswersListWidget(
          user: widget.user,
          questionId: widget.question?.id,
          answers: answers,
        ),
      );
    }

    return TextButton(
      onPressed: () => widget.onSubmitTapped(),
      child: const SizedBox(
        height: 100,
        child: Center(child: Text("Submit Answer")),
      ),
    );
  }
}
