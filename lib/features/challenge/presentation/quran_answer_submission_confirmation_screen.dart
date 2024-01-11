import 'package:flutter/material.dart';

import 'widgets/create/quran_single_action_button_widget.dart';

class QuranAnswerSubmissionConfirmationScreen extends StatelessWidget {
  final String answerId;

  const QuranAnswerSubmissionConfirmationScreen({
    Key? key,
    required this.answerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        /// APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Success"),
        ),

        /// BODY
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              30,
              10,
              30,
              10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 250,
                  color: Colors.green,
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      "Thank You.\n\nRef: $answerId\n\n\nYour answer has been submitted successfully for review.\n\nIt will be published upon approval.",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                QuranSingleActionButtonWidget(
                  buttonText: "Close",
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
