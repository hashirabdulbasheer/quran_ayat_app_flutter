import 'package:flutter/material.dart';

import '../../../../models/qr_user_model.dart';
import '../../domain/models/quran_answer.dart';
import 'quran_answers_list_widget.dart';

class QuranAnswerBodyWidget extends StatelessWidget {
  final QuranUser? user;
  final List<QuranAnswer>? answers;

  const QuranAnswerBodyWidget({
    Key? key,
    required this.user,
    required this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (answers != null && answers?.isNotEmpty == true) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: QuranAnswersListWidget(
          user: user,
          answers: answers ?? [],
        ),
      );
    }

    return TextButton(
      onPressed: () {},
      child: const SizedBox(
        height: 100,
        child: Center(child: Text("Submit Answer")),
      ),
    );
  }
}
