import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:quran_ayat/features/auth/domain/auth_factory.dart';
import 'package:quran_ayat/features/challenge/domain/challenge_manager.dart';
import 'package:quran_ayat/features/challenge/domain/enums/quran_answer_status_enum.dart';
import 'package:quran_ayat/features/challenge/domain/models/quran_answer.dart';
import 'package:quran_ayat/features/challenge/domain/models/quran_question.dart';
import 'package:quran_ayat/features/challenge/domain/redux/actions/actions.dart';
import 'package:quran_ayat/features/challenge/presentation/quran_answer_submission_confirmation_screen.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:quran_ayat/utils/utils.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import '../../../models/qr_user_model.dart';
import '../../ayats/presentation/widgets/ayat_display_header_widget.dart';
import '../../core/domain/app_state/app_state.dart';
import 'widgets/create/quran_arabic_translation_widget.dart';
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
  String note = "";
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

                const Text(
                  "Select a verse that could answer the question",
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(
                  height: 5,
                ),

                /// HEADER - AYA SELECTION
                QuranAyatHeaderWidget(
                  surahTitles: store.state.reader.surahTitles,
                  onSurahSelected: (surah) => setState(() => {
                        currentSurahDetails = surah,
                        currentIndex = SurahIndex(
                          surah.number - 1,
                          0,
                        ),
                      }),
                  onAyaNumberSelected: (aya) => setState(
                    () => currentIndex = SurahIndex(
                      currentSurahDetails.number - 1,
                      aya,
                    ),
                  ),
                  currentlySelectedSurah: currentSurahDetails,
                  currentIndex: currentIndex ?? SurahIndex.defaultIndex,
                ),

                const SizedBox(
                  height: 10,
                ),

                /// REST OF CONTENT

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
                  isLoading: isLoading,
                  onPressed: () => _displayRemovalConfirmationDialog(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitAnswerTapped() {
    /// validate
    if (currentIndex == null) {
      QuranUtils.showMessage(
        context,
        "Please select an aya",
      );

      return;
    }

    if (_notesController.text.isEmpty) {
      QuranUtils.showMessage(
        context,
        "Please enter a note",
      );

      return;
    }

    if (isLoading) {
      return;
    }

    /// proceed to submission
    setState(() {
      isLoading = true;
    });
    QuranUser? user = QuranAuthFactory.engine.getUser();
    if (user == null) {
      QuranUtils.showMessage(
        context,
        "Please login",
      );

      return;
    }

    QuranAnswer answer = QuranAnswer(
      id: const Uuid().v4(),
      surah: currentIndex!.sura,
      aya: currentIndex!.aya,
      userId: user.uid,
      username: user.name,
      note: _notesController.text,
      createdOn: DateTime.now().millisecondsSinceEpoch,
      status: QuranAnswerStatusEnum.submitted,
    );

    QuranChallengeManager.instance.submitAnswer(
      user.uid,
      widget.question.id,
      answer,
    );

    StoreProvider.of<AppState>(context)
        .dispatch(InitializeChallengeScreenAction(questions: const []));

    setState(() {
      isLoading = true;
    });

    Navigator.of(context).pop();

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => const QuranAnswerSubmissionConfirmationScreen(),
      ),
    ).then((value) {});

    // QuranUtils.showMessage(
    //   context,
    //   "Submitted successfully for review.",
    // );
  }

  Future<void> _displayRemovalConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          title: const Text(
            'Submit answer?',
          ),
          content: const Text(
            "Are you sure that you want to submit the answer?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            MaterialButton(
              color: Colors.blueGrey,
              textColor: Colors.white,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
                _onSubmitAnswerTapped(),
              },
            ),
          ],
        );
      },
    );
  }
}
