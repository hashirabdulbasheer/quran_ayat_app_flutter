import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../models/qr_user_model.dart';
import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../domain/enums/quran_answer_status_enum.dart';
import '../domain/models/quran_question.dart';
import '../domain/redux/actions/actions.dart';
import 'quran_create_question_screen.dart';
import 'widgets/answers/quran_reload_button_widget.dart';
import 'widgets/submissions/quran_submission_question_item_widget.dart';

class QuranChallengesApprovalScreen extends StatefulWidget {
  const QuranChallengesApprovalScreen({Key? key}) : super(key: key);

  @override
  State<QuranChallengesApprovalScreen> createState() =>
      _QuranChallengesApprovalScreenState();
}

class _QuranChallengesApprovalScreenState
    extends State<QuranChallengesApprovalScreen> {
  QuranAnswerStatusEnum _selectedStatus = QuranAnswerStatusEnum.undefined;

  @override
  Widget build(BuildContext context) {
    QuranUser? user = QuranAuthFactory.engine.getUser();

    return StoreBuilder<AppState>(builder: (
      BuildContext context,
      Store<AppState> store,
    ) {
      List<QuranQuestion> questions = _filterQuestions(store);

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          /// APP BAR
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Approvals"),
            actions: [
              QuranReloadButtonWidget(action: () => _reloadQuestions(store)),
              IconButton(
                onPressed: () => _addQuestion(store),
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ],
          ),

          /// BODY
          body: user == null
              ? const Center(child: Text('No submissions'))
              : Directionality(
                  textDirection: TextDirection.ltr,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<QuranAnswerStatusEnum>(
                            items: const [
                              QuranAnswerStatusEnum.undefined,
                              QuranAnswerStatusEnum.submitted,
                              QuranAnswerStatusEnum.approved,
                              QuranAnswerStatusEnum.rejected,
                            ],
                            enabled: true,
                            itemAsString: (QuranAnswerStatusEnum status) =>
                                status.rawString(),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              baseStyle: TextStyle(fontSize: 12),
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Status",
                                hintText: "select status",
                              ),
                              textAlign: TextAlign.start,
                            ),
                            onChanged: (value) => {
                              setState(() {
                                if (value != null) {
                                  _selectedStatus = value;
                                }
                              }),
                            },
                            selectedItem: _selectedStatus,
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: questions.length,
                          shrinkWrap: true,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return QuranSubmissionQuestionItemWidget(
                              question: questions[index],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }

  List<QuranQuestion> _filterQuestions(Store<AppState> store) {
    List<QuranQuestion> questions =
        List.from(store.state.challenge.allQuestions);
    if (_selectedStatus == QuranAnswerStatusEnum.undefined) {
      return questions;
    }
    List<QuranQuestion> filtered = [];
    for (QuranQuestion question in questions) {
      var answers = question.answers
          .where((element) => element.status == _selectedStatus)
          .toList();
      filtered.add(question.copyWith(answers: answers));
    }

    return filtered;
  }

  void _reloadQuestions(Store<AppState> store) async {
    store.dispatch(InitializeChallengeScreenAction(questions: const []));
  }

  void _addQuestion(Store<AppState> store) async {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => const QuranCreateQuestionScreen(),
      ),
    );
  }
}
