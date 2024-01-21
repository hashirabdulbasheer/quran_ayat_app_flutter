import 'package:flutter/material.dart';

import '../../../domain/challenge_manager.dart';
import '../../../domain/enums/quran_answer_status_enum.dart';
import '../../../domain/models/quran_answer.dart';

class QuranSubmissionAnswerItemWidget extends StatelessWidget {
  final QuranAnswer answer;

  const QuranSubmissionAnswerItemWidget({
    Key? key,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String note = answer.note;
    if (note.length > 300) {
      note = note.substring(
        0,
        300,
      );
      note = "$note...";
    }

    String formattedStatus = _formattedStatus(answer.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10,
        0,
        10,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(answer.username),

          const SizedBox(
            height: 10,
          ),

          /// Note
          Text(
            "${answer.surah + 1}:${answer.aya + 1} - $note",
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          /// Status
          if (formattedStatus.isNotEmpty)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formattedStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: _colorForStatus(answer.status),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (answer.rejectedReason != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          "(${answer.rejectedReason})",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: _colorForStatus(answer.status),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

          if (formattedStatus.isNotEmpty)
            const SizedBox(
              height: 5,
            ),

          /// Submitted time
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Submitted ${QuranChallengeManager.instance.formattedDate(answer.createdOn)}",
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formattedStatus(QuranAnswerStatusEnum status) {
    if (status == QuranAnswerStatusEnum.submitted) {
      return "Under review";
    } else if (status == QuranAnswerStatusEnum.approved) {
      return "Approved";
    } else if (status == QuranAnswerStatusEnum.rejected) {
      return "Not Approved";
    } else {
      return "";
    }
  }

  Color _colorForStatus(QuranAnswerStatusEnum status) {
    // if (status == QuranAnswerStatusEnum.submitted) {
    //   return Colors.orange;
    // } else if (status == QuranAnswerStatusEnum.approved) {
    //   return Colors.green;
    // } else if (status == QuranAnswerStatusEnum.rejected) {
    //   return Colors.red;
    // } else {
    //   return Colors.black;
    // }
    if (status == QuranAnswerStatusEnum.rejected) {
      return Colors.red;
    } else if (status == QuranAnswerStatusEnum.approved) {
      return Colors.green;
    }

    return Colors.black;
  }
}
