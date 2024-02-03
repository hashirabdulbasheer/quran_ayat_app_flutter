import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../../misc/design/design_system.dart';
import '../../../../../models/qr_user_model.dart';
import '../../../../../utils/logger_utils.dart';
import '../../../../../utils/utils.dart';
import '../../../../auth/domain/auth_factory.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../core/presentation/shimmer.dart';
import '../../../domain/models/quran_question.dart';
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
          decoration: QuranDS.boxDecorationVeryLightBorder,
          padding: const EdgeInsets.fromLTRB(
            10,
            0,
            10,
            0,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Submissions',
                ),
                Expanded(child: Text(_getSubmissionsCount())),
                ElevatedButton(
                  onPressed: () => _goToCreateChallengeScreen(
                    user,
                    widget.question,
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),
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

  String _getSubmissionsCount() {
    return widget.question?.answers.isNotEmpty == true
        ? " (${widget.question?.answers.length}) "
        : "";
  }

  void _goToLoginScreen() {
    Navigator.pushNamed(
      context,
      "/login",
    ).then((value) => setState(() {}));
    QuranLogger.logAnalytics("answer-add-login");
  }

  void _goToCreateChallengeScreen(
    QuranUser? user,
    QuranQuestion? question,
  ) {
    if (user == null) {
      _goToLoginScreen();
    } else {
      if (question != null) {
        Navigator.pushNamed(
          context,
          "/createChallenge",
          arguments: question,
        );
        QuranLogger.logAnalytics("answer-add-screen");
      } else {
        QuranUtils.showMessage(
          context,
          "Invalid question !",
        );
        QuranLogger.logAnalytics("answer-add-invalid");
      }
    }
  }
}
