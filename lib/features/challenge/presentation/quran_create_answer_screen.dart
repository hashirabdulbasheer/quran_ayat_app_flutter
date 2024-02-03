import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import '../../../misc/enums/quran_status_enum.dart';
import '../../../misc/router/router_utils.dart';
import '../../../models/qr_user_model.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/logger_utils.dart';
import '../../../utils/utils.dart';
import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../newAyat/data/surah_index.dart';
import '../../notes/domain/entities/quran_note.dart';
import '../../notes/domain/notes_manager.dart';
import '../../notes/domain/redux/actions/actions.dart';
import '../domain/challenge_manager.dart';
import '../domain/enums/quran_answer_status_enum.dart';
import '../domain/models/quran_answer.dart';
import '../domain/models/quran_question.dart';
import '../domain/redux/actions/actions.dart';
import 'widgets/create/quran_arabic_translation_widget.dart';
import 'widgets/create/quran_ayat_selection_widget.dart';
import 'widgets/create/quran_single_action_button_widget.dart';
import 'widgets/create/quran_small_tappable_textfield_widget.dart';

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
  NQSurahTitle _currentSurahDetails = NQSurahTitle.defaultValue();
  SurahIndex? _currentIndex;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);

    return Scaffold(
      /// APP BAR
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Submit Answer"),
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),

              /// The Question
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.question.title,
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.question.question,
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const Divider(),

              const SizedBox(
                height: 5,
              ),

              /// AYA SELECTION
              QuranAyatSelectionWidget(
                store: store,
                title: "Select a verse that could answer the question",
                currentIndex: _currentIndex ?? SurahIndex.defaultIndex,
                currentSurahDetails: _currentSurahDetails,
                onSuraSelected: (surah) => setState(() => {
                      _currentSurahDetails = surah,
                      _currentIndex = SurahIndex(
                        surah.number - 1,
                        0,
                      ),
                    }),
                onAyaSelected: (aya) => setState(
                  () => _currentIndex = SurahIndex(
                    _currentSurahDetails.number - 1,
                    aya,
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              /// VERSE DISPLAY
              if (_currentIndex != null)
                QuranArabicTranslationWidget(
                  index: _currentIndex ?? SurahIndex.defaultIndex,
                ),

              const SizedBox(
                height: 20,
              ),

              /// NOTES TEXT FIELD
              QuranTappableSmallTextFieldWidget(
                title:
                    "Enter notes/reflection on how the verse answers the question",
                controller: _notesController,
              ),

              const SizedBox(
                height: 50,
              ),

              /// SUBMIT BUTTON
              QuranSingleActionButtonWidget(
                buttonText: "Submit",
                isLoading: _isLoading,
                onPressed: () => _isValidForm()
                    ? DialogUtils.confirmationDialog(
                        context,
                        'Submit answer?',
                        "Are you sure that you want to submit the answer for review?",
                        'Submit',
                        () => _onSubmitAnswerTapped(),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Validation
  bool _isValidForm() {
    /// validate
    if (_currentIndex == null) {
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

    if (_isLoading) {
      return false;
    }

    return true;
  }

  /// ACTION
  void _onSubmitAnswerTapped() {
    /// proceed to submission
    setState(() {
      _isLoading = true;
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
      surah: _currentIndex!.sura,
      aya: _currentIndex!.aya,
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

    /// Also save as a note
    QuranNote note = QuranNote(
      suraIndex: _currentIndex!.sura,
      ayaIndex: _currentIndex!.aya,
      note: 'Answer to ${widget.question.title}: ${_notesController.text}',
      localId: "",
      createdOn: DateTime.now().millisecondsSinceEpoch,
      status: QuranStatusEnum.created,
    );
    QuranNotesManager.instance.create(
      user.uid,
      note,
    );

    /// Move to next screen after a delay to show a loading state
    Future.delayed(
      const Duration(milliseconds: 500),
      () => {
        /// Fetch the questions again
        StoreProvider.of<AppState>(context)
            .dispatch(InitializeChallengeScreenAction(questions: const [])),

        StoreProvider.of<AppState>(context).dispatch(FetchNotesAction()),

        setState(() {
          _isLoading = true;
        }),

        /// Dismiss screen
        Navigator.of(context).pop(),

        /// Display confirmation screen
        QuranNavigator.of(context).routeToConfirmation(answerId),
      },
    );

    QuranLogger.logAnalyticsWithParams(
      "create-answer-submit-done",
      {'questionId': widget.question.id},
    );
  }
}
