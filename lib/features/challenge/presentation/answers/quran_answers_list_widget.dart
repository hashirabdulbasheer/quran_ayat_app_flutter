import 'package:flutter/material.dart';
import 'package:quran_ayat/features/challenge/domain/challenge_manager.dart';

import '../../../../models/qr_user_model.dart';
import '../../../../utils/utils.dart';
import '../../../notes/domain/notes_manager.dart';
import '../../domain/models/quran_answer.dart';

class QuranAnswersListWidget extends StatelessWidget {
  final QuranUser? user;
  final List<QuranAnswer> answers;

  const QuranAnswersListWidget({
    Key? key,
    required this.user,
    required this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: answers.length,
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
        TextDirection textDirection = TextDirection.ltr;
        if (!QuranUtils.isEnglish(answers[index].note)) {
          textDirection = TextDirection.rtl;
        }

        return Directionality(
          textDirection: textDirection,
          child: ListTile(
            onTap: () {
              // TODO: Implement action onTap of an answer
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    answers[index].username,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${answers[index].surah+1}:${answers[index].aya+1} - ${answers[index].note}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    QuranChallengeManager.instance.formattedDate(
                      answers[index].createdOn,
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
