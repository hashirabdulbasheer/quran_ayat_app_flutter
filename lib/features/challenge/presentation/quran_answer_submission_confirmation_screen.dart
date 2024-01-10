import 'package:flutter/material.dart';

class QuranAnswerSubmissionConfirmationScreen extends StatelessWidget {
  const QuranAnswerSubmissionConfirmationScreen({Key? key}) : super(key: key);

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
                const Center(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      "Thank You.\n\nYour answer has been submitted successfully for review.\n\nIt will be published upon approval.",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Close"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
