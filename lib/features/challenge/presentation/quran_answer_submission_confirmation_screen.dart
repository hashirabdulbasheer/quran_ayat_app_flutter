import 'package:flutter/material.dart';

import '../../../misc/router/router_utils.dart';
import 'widgets/create/quran_single_action_button_widget.dart';

class QuranAnswerSubmissionConfirmationScreen extends StatelessWidget {
  final String answerId;

  const QuranAnswerSubmissionConfirmationScreen({
    super.key,
    required this.answerId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Column(
                  children: [
                    const Text(
                      "Good Job",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Ref: $answerId",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Your answer has been submitted successfully for review.\n\nIt will be published upon approval.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              QuranSingleActionButtonWidget(
                buttonText: "Close",
                onPressed: () => {
                  /// dismiss confirmation screen
                  Navigator.of(context).pop(),

                  /// navigate to my submissions list screen
                  QuranNavigator.of(context).routeToMySubmissions(),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
