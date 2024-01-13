import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:quran_ayat/utils/utils.dart';
import 'package:redux/redux.dart';

import '../../../models/qr_user_model.dart';
import '../../../utils/dialog_utils.dart';
import '../../auth/domain/auth_factory.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../newAyat/data/surah_index.dart';
import '../../notes/presentation/widgets/notes_update_controls_widget.dart';
import '../domain/challenge_manager.dart';
import '../domain/enums/quran_answer_status_enum.dart';
import '../domain/models/quran_answer.dart';
import '../domain/redux/actions/actions.dart';
import 'widgets/create/quran_arabic_translation_widget.dart';
import 'widgets/create/quran_ayat_selection_widget.dart';
import 'widgets/create/quran_note_entry_textfield_widget.dart';

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
  bool isDeleteLoading = false;
  bool isUpdateLoading = false;

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
                QuranUpdateControlsWidget(
                  onDelete: () => _onDeleteTapped(),
                  onUpdate: () => _onUpdateTapped(),
                  isDeleteLoading: isDeleteLoading,
                  isUpdateLoading: isUpdateLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDeleteTapped() {
    DialogUtils.confirmationDialog(
      context,
      "Delete?",
      "Are you sure that you want to delete?",
      "Delete",
      () => _deleteAnswer(),
    );
  }

  void _onUpdateTapped() {
    if (!_isValidForm()) {
      return;
    }

    DialogUtils.confirmationDialog(
      context,
      "Update?",
      "Are you sure that you want to update?",
      "Update",
      () => _updateAnswer(),
    );
  }

  /// Validation
  bool _isValidForm() {
    /// validate
    if (currentIndex == null) {
      QuranUtils.showMessage(
        context,
        "Please select an aya",
      );

      return false;
    }

    if (_notesController.text.isEmpty) {
      QuranUtils.showMessage(
        context,
        "Please enter a note",
      );

      return false;
    }

    if (isDeleteLoading || isUpdateLoading) {
      return false;
    }

    return true;
  }

  /// ACTION
  void _updateAnswer() {
    /// proceed to submission
    setState(() {
      isUpdateLoading = true;
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
    QuranAnswer answer = widget.answer;
    answer.status = QuranAnswerStatusEnum.submitted;
    answer.note = _notesController.text;
    answer.surah = currentIndex!
        .sura; // current index cannot be null here as its checked before
    answer.aya = currentIndex!.aya;
    answer.createdOn = DateTime.now().millisecondsSinceEpoch;

    /// Submit answer
    QuranChallengeManager.instance.editAnswer(
      user.uid,
      widget.questionId,
      answer,
    );

    /// Reload after a delay
    Future.delayed(
      const Duration(milliseconds: 500),
      () => {
        /// Fetch the questions again
        StoreProvider.of<AppState>(context)
            .dispatch(InitializeChallengeScreenAction(questions: const [])),

        setState(() {
          isUpdateLoading = false;
        }),

        /// Dismiss screen
        Navigator.of(context).pop(true),

        /// Display confirmation
        QuranUtils.showMessage(
          context,
          "Updated successfully. Submitted for review.",
        ),
      },
    );
  }

  void _deleteAnswer() {
    /// proceed to submission
    setState(() {
      isDeleteLoading = true;
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

    /// Delete
    QuranChallengeManager.instance.deleteAnswer(
      user.uid,
      widget.questionId,
      widget.answer,
    );

    /// Delete - after a delay for the delete to reflect
    Future.delayed(
      const Duration(milliseconds: 500),
      () => {
        /// Fetch the questions again
        StoreProvider.of<AppState>(context)
            .dispatch(InitializeChallengeScreenAction(questions: const [])),

        setState(() {
          isDeleteLoading = false;
        }),

        /// Dismiss screen
        Navigator.of(context).pop(true),

        /// Display confirmation
        QuranUtils.showMessage(
          context,
          "Deleted successfully.",
        ),
      },
    );
  }
}
