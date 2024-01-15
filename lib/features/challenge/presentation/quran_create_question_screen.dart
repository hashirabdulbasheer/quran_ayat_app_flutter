import 'package:flutter/material.dart';
import 'package:quran_ayat/features/challenge/presentation/widgets/create/quran_single_action_button_widget.dart';

class QuranCreateQuestionScreen extends StatefulWidget {
  const QuranCreateQuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuranCreateQuestionScreen> createState() =>
      _QuranCreateQuestionScreenState();
}

class _QuranCreateQuestionScreenState extends State<QuranCreateQuestionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        /// APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create Question"),
        ),

        /// BODY
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
