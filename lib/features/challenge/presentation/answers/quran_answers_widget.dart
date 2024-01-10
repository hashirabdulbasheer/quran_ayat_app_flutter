import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../models/qr_user_model.dart';
import '../../../auth/domain/auth_factory.dart';
import '../../../core/domain/app_state/app_state.dart';
import '../../../core/presentation/shimmer.dart';
import '../../domain/models/quran_answer.dart';
import 'quran_answers_body_widget.dart';

class QuranAnswersWidget extends StatefulWidget {
  final List<QuranAnswer> answers;

  const QuranAnswersWidget({
    Key? key,
    required this.answers,
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
                onPressed: () {},
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        QuranShimmer(
          isLoading: StoreProvider.of<AppState>(context).state.challenge.isLoading,
          child: QuranAnswerBodyWidget(
            user: user,
            answers: widget.answers,
          ),
        ),
      ],
    );
  }
}
