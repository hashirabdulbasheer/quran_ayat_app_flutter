import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quran_ayat/features/challenge/domain/models/quran_question.dart';
import 'package:quran_ayat/utils/utils.dart';
import '../../../../../models/qr_user_model.dart';
import '../../../../../utils/logger_utils.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../auth/presentation/quran_login_screen.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../core/presentation/shimmer.dart';
import '../../quran_create_answer_screen.dart';
import 'quran_answers_body_widget.dart';

class QuranAnswersWidget extends StatefulWidget {
  final QuranQuestion? question;

  const QuranAnswersWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<QuranAnswersWidget> createState() => _QuranAnswersWidgetState();
}

class _QuranAnswersWidgetState extends State<QuranAnswersWidget> {
  @override
  Widget build(BuildContext context) {
    QuranUser? user = QuranAuthFactory.engine.getUser();

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.black12),
            ),
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.fromLTRB(
            10,
            0,
            10,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Submissions"),
              ElevatedButton(
                onPressed: () => _goToCreateChallengeScreen(
                  user,
                  widget.question,
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        QuranShimmer(
          isLoading:
              StoreProvider.of<AppState>(context).state.challenge.isLoading,
          child: QuranAnswerBodyWidget(
            user: user,
            question: widget.question,
            onSubmitTapped: () => _goToCreateChallengeScreen(
              user,
              widget.question,
            ),
          ),
        ),
      ],
    );
  }

  void _goToLoginScreen() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const QuranLoginScreen()),
    ).then((value) {
      setState(() {});
    });
  }

  void _goToCreateChallengeScreen(
    QuranUser? user,
    QuranQuestion? question,
  ) {
    if (user == null) {
      _goToLoginScreen();
    } else {
      if (question != null) {
        Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (context) => QuranCreateChallengeScreen(
              question: question,
            ),
          ),
        ).then((value) {});
        QuranLogger.logAnalytics("add_challenge");
      } else {
        QuranUtils.showMessage(
          context,
          "Invalid question !",
        );
      }
    }
  }
}
