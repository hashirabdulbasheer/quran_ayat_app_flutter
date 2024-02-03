import 'package:flutter/material.dart';
import 'package:quran_ayat/utils/dialog_utils.dart';
import 'package:quran_ayat/utils/utils.dart';

import '../domain/challenge_manager.dart';
import '../domain/enums/quran_question_status_enum.dart';
import '../domain/models/quran_question.dart';
import 'widgets/create/quran_single_action_button_widget.dart';

class QuranCreateQuestionScreen extends StatefulWidget {
  const QuranCreateQuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuranCreateQuestionScreen> createState() =>
      _QuranCreateQuestionScreenState();
}

class _QuranCreateQuestionScreenState extends State<QuranCreateQuestionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// APP BAR
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create Question"),
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  labelText: 'Title',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                controller: _questionController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Question',
                  labelText: 'Question',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              QuranSingleActionButtonWidget(
                buttonText: "Submit",
                onPressed: () => {
                  DialogUtils.confirmationDialog(
                    context,
                    "Submit?",
                    "Are you sure?",
                    "Submit",
                    () => _onSubmit(),
                  ),
                },
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    String title = _titleController.text;
    String questionText = _questionController.text;
    if (title.isEmpty || questionText.isEmpty) {
      QuranUtils.showMessage(
        context,
        "Please enter both title and question",
      );

      return;
    }

    QuranQuestion question = QuranQuestion(
      id: 0,
      title: title,
      question: questionText,
      status: QuranQuestionStatusEnum.undefined,
      createdOn: DateTime.now().millisecondsSinceEpoch,
      answers: const [],
    );

    /// TODO: Used only by admin, so ignoring error during question creation for now
    QuranChallengeManager.instance.createQuestion(question);
    setState(() {
      _isLoading = false;
    });
    QuranUtils.showMessage(
      context,
      "Question created successfully",
    );
    Navigator.of(context).pop();
  }
}
