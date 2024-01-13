import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:quran_ayat/utils/utils.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import '../../../models/qr_user_model.dart';
import '../../../utils/dialog_utils.dart';
import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../newAyat/data/surah_index.dart';
import '../domain/challenge_manager.dart';
import '../domain/enums/quran_answer_status_enum.dart';
import '../domain/models/quran_answer.dart';
import '../domain/models/quran_question.dart';
import '../domain/redux/actions/actions.dart';
import 'quran_answer_submission_confirmation_screen.dart';
import 'widgets/create/quran_arabic_translation_widget.dart';
import 'widgets/create/quran_ayat_selection_widget.dart';
import 'widgets/create/quran_note_entry_textfield_widget.dart';
import 'widgets/create/quran_single_action_button_widget.dart';

class QuranCreateChallengeScreen extends StatefulWidget {
  final QuranQuestion question;

  const QuranCreateChallengeScreen({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<QuranCreateChallengeScreen> createState() =>
      _QuranCreateChallengeScreenState();
}

class _QuranCreateChallengeScreenState
    extends State<QuranCreateChallengeScreen> {
  final TextEditingController _notesController = TextEditingController();
  NQSurahTitle currentSurahDetails = NQSurahTitle.defaultValue();
  SurahIndex? currentIndex;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        /// APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Submit Answer"),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 10,
                ),

                /// AYA SELECTION
                QuranAyatSelectionWidget(
                  store: store,
                  title: "Select a verse that could answer the question",
                  currentIndex: currentIndex ?? SurahIndex.defaultIndex,
                  currentSurahDetails: currentSurahDetails,
                  onSuraSelected: (surah) => setState(() => {
                        currentSurahDetails = surah,
                        currentIndex = SurahIndex(
                          surah.number - 1,
                          0,
                        ),
                      }),
                  onAyaSelected: (aya) => setState(
                    () => currentIndex = SurahIndex(
                      currentSurahDetails.number - 1,
                      aya,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                /// VERSE DISPLAY
                if (currentIndex != null)
                  QuranArabicTranslationWidget(
                    index: currentIndex ?? SurahIndex.defaultIndex,
                  ),

                const SizedBox(
                  height: 20,
                ),

                /// NOTES TEXT FIELD
                QuranNotesTextFieldWidget(
                  title:
                      "Enter notes/reflection on how the verse answers the question",
                  textEditingController: _notesController,
                ),

                const SizedBox(
                  height: 50,
                ),

                /// SUBMIT BUTTON
                QuranSingleActionButtonWidget(
                  buttonText: "Submit",
                  isLoading: isLoading,
                  onPressed: () => _isValidForm()
                      ? DialogUtils.confirmationDialog(
                          context,
                          'Submit answer?',
                          "Are you sure that you want to submit the answer?",
                          'Submit',
                          () => _onSubmitAnswerTapped(),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Validation
  bool _isValidForm() {
    /// validate
    if (currentIndex == null) {
      QuranUtils.showMessage(
        context,
        "Please select an aya that answers the question",
      );

      return false;
    }

    if (_notesController.text.isEmpty) {
      QuranUtils.showMessage(
        context,
        "Please enter a note about your reflection on the aya",
      );

      return false;
    }

    if (isLoading) {
      return false;
    }

    return true;
  }

  /// ACTION
  void _onSubmitAnswerTapped() {
    /// proceed to submission
    setState(() {
      isLoading = true;
    });

    /// Get User details
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      QuranUtils.showMessage(
        context,
        "Please login",
      );

      return;
    }

    /// Create answer
    String answerId = const Uuid().v4();
    QuranAnswer answer = QuranAnswer(
      id: answerId,
      surah: currentIndex!.sura,
      aya: currentIndex!.aya,
      userId: user.uid,
      username: user.name,
      note: _notesController.text,
      createdOn: DateTime.now().millisecondsSinceEpoch,
      status: QuranAnswerStatusEnum.submitted,
    );

    /// Submit answer
    QuranChallengeManager.instance.submitAnswer(
      user.uid,
      widget.question.id,
      answer,
    );

    /// Move to next screen after a delay to show a loading state
    Future.delayed(
      const Duration(milliseconds: 500),
      () => {
        /// Fetch the questions again
        StoreProvider.of<AppState>(context)
            .dispatch(InitializeChallengeScreenAction(questions: const [])),

        setState(() {
          isLoading = true;
        }),

        /// Dismiss screen
        Navigator.of(context).pop(),

        /// Display confirmation screen
        Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (context) => QuranAnswerSubmissionConfirmationScreen(
              answerId: answerId,
            ),
          ),
        ).then((value) {}),
      },
    );
  }
}
