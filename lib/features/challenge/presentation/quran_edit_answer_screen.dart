import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:redux/redux.dart';

import '../../../models/qr_user_model.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/utils.dart';
import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../newAyat/data/surah_index.dart';
import '../../notes/presentation/widgets/notes_update_controls_widget.dart';
import '../domain/challenge_manager.dart';
import '../domain/enums/quran_answer_status_enum.dart';
import '../domain/models/quran_answer.dart';
import '../domain/models/quran_question.dart';
import '../domain/redux/actions/actions.dart';
import 'widgets/create/quran_arabic_translation_widget.dart';
import 'widgets/create/quran_ayat_selection_widget.dart';
import 'widgets/create/quran_small_tappable_textfield_widget.dart';

enum QuranEditAnswerScreenLoadingAction {
  update,
  delete,
  approve,
  reject,
  none,
}

class QuranEditAnswerScreen extends StatefulWidget {
  final int questionId;
  final QuranAnswer answer;

  const QuranEditAnswerScreen({
    Key? key,
    required this.questionId,
    required this.answer,
  }) : super(key: key);

  @override
  State<QuranEditAnswerScreen> createState() => _QuranEditAnswerScreenState();
}

class _QuranEditAnswerScreenState extends State<QuranEditAnswerScreen> {
  final TextEditingController _notesController = TextEditingController();
  NQSurahTitle currentSurahDetails = NQSurahTitle.defaultValue();
  SurahIndex? currentIndex;
  QuranEditAnswerScreenLoadingAction? currentLoadingAction =
      QuranEditAnswerScreenLoadingAction.none;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.answer.note;
    currentIndex = SurahIndex(
      widget.answer.surah,
      widget.answer.aya,
    );
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    currentSurahDetails = store.state.reader.surahTitles[widget.answer.surah];
    QuranQuestion question = store.state.challenge.allQuestions
        .where((element) => element.id == widget.questionId)
        .first;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        /// APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Edit Answer"),
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

                /// The Question
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        question.title,
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        question.question,
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
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
                  height: 20,
                ),

                /// SUBMIT BUTTON
                QuranUpdateControlsWidget(
                  positiveActionText: "Update",
                  onPositiveAction: () => onConfirmation(
                    title: "Update?",
                    message: "Are you sure that you want to update?",
                    action: "Update",
                    onConfirmation: () => _updateAnswer(),
                  ),
                  isPositiveActionRunning: currentLoadingAction ==
                      QuranEditAnswerScreenLoadingAction.update,
                  negativeActionText: "Delete",
                  onNegativeAction: () => onConfirmation(
                    title: "Delete?",
                    message: "Are you sure that you want to delete?",
                    action: "Delete",
                    onConfirmation: () => _deleteAnswer(),
                  ),
                  isNegativeActionRunning: currentLoadingAction ==
                      QuranEditAnswerScreenLoadingAction.delete,
                ),

                const SizedBox(
                  height: 10,
                ),

                /// ADMIN Functionality
                if (store.state.isAdminUser)
                  QuranUpdateControlsWidget(
                    positiveActionText: "Approve",
                    onPositiveAction: () => onConfirmation(
                      title: "Approve?",
                      message: "Are you sure that you want to approve?",
                      action: "Approve",
                      onConfirmation: () => _approveAnswer(),
                    ),
                    isPositiveActionRunning: currentLoadingAction ==
                        QuranEditAnswerScreenLoadingAction.approve,
                    negativeActionText: "Reject",
                    onNegativeAction: () => onConfirmation(
                      title: "Reject?",
                      message: "Are you sure that you want to reject?",
                      action: "Reject",
                      onConfirmation: () => _rejectAnswer(),
                    ),
                    isNegativeActionRunning: currentLoadingAction ==
                        QuranEditAnswerScreenLoadingAction.reject,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onConfirmation({
    required String title,
    required String message,
    required String action,
    required Function onConfirmation,
  }) {
    DialogUtils.confirmationDialog(
      context,
      title,
      message,
      action,
      () => onConfirmation(),
    );
  }

  /// ACTION
  void _updateAnswer() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      QuranUtils.showMessage(
        context,
        "Please login",
      );

      return;
    }
    // Execute
    _executeAction(
      user: user,
      action: () {
        QuranAnswer answer = widget.answer.copyWith(
          status: QuranAnswerStatusEnum.submitted,
          note: _notesController.text,
          surah: currentIndex!.sura,
          // current index cannot be null here as its checked before
          aya: currentIndex!.aya,
          createdOn: DateTime.now().millisecondsSinceEpoch,
        );

        /// Submit answer
        QuranChallengeManager.instance.editAnswer(
          user.uid,
          widget.questionId,
          answer,
        );
      },
      postAction: () => {
        /// Fetch the questions again
        StoreProvider.of<AppState>(context)
            .dispatch(InitializeChallengeScreenAction(questions: const [])),

        setState(() {
          currentLoadingAction = QuranEditAnswerScreenLoadingAction.none;
        }),

        /// Dismiss screen
        Navigator.of(context).pop(true),

        /// Display confirmation
        QuranUtils.showMessage(
          context,
          "Updated successfully. Submitted for review.",
        ),
      },
      loadingAction: QuranEditAnswerScreenLoadingAction.update,
    );
  }

  void _deleteAnswer() {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      QuranUtils.showMessage(
        context,
        "Please login",
      );

      return;
    }

    // Execute
    _executeAction(
      user: user,
      action: () => {
        /// Delete
        QuranChallengeManager.instance.deleteAnswer(
          user.uid,
          widget.questionId,
          widget.answer,
        ),
      },
      postAction: () => {
        /// Fetch the questions again
        StoreProvider.of<AppState>(context)
            .dispatch(InitializeChallengeScreenAction(questions: const [])),

        setState(() {
          currentLoadingAction = QuranEditAnswerScreenLoadingAction.none;
        }),

        /// Dismiss screen
        Navigator.of(context).pop(true),

        /// Display confirmation
        QuranUtils.showMessage(
          context,
          "Deleted successfully.",
        ),
      },
      loadingAction: QuranEditAnswerScreenLoadingAction.delete,
    );
  }

  void _approveAnswer() {
    _updateAnswerStatus(
      status: QuranAnswerStatusEnum.approved,
      loadingAction: QuranEditAnswerScreenLoadingAction.approve,
    );
  }

  void _rejectAnswer() {
    _updateAnswerStatus(
      status: QuranAnswerStatusEnum.rejected,
      loadingAction: QuranEditAnswerScreenLoadingAction.reject,
    );
  }

  void _updateAnswerStatus({
    required QuranAnswerStatusEnum status,
    required QuranEditAnswerScreenLoadingAction loadingAction,
  }) {
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      QuranUtils.showMessage(
        context,
        "Please login",
      );

      return;
    }

    // Execute action
    QuranAnswer answer = widget.answer.copyWith(status: status);
    _executeAction(
      user: user,
      action: () => {
        /// Submit answer
        QuranChallengeManager.instance.editAnswer(
          user.uid,
          widget.questionId,
          answer,
        ),
      },
      postAction: () => {
        /// Fetch the questions again
        StoreProvider.of<AppState>(context)
            .dispatch(InitializeChallengeScreenAction(questions: const [])),

        setState(() {
          currentLoadingAction = QuranEditAnswerScreenLoadingAction.none;
        }),

        /// Dismiss screen
        Navigator.of(context).pop(true),

        /// Display confirmation
        QuranUtils.showMessage(
          context,
          "Updated successfully.",
        ),
      },
      loadingAction: loadingAction,
    );
  }

  void _executeAction({
    required QuranUser? user,
    required Function action,
    required Function postAction,
    required QuranEditAnswerScreenLoadingAction loadingAction,
  }) {
    /// proceed to submission
    setState(() {
      currentLoadingAction = loadingAction;
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

    /// Action
    action();

    /// Reload after a delay
    Future<void>.delayed(
      const Duration(milliseconds: 500),
      () => postAction(),
    );
  }
}
