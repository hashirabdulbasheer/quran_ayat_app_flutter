import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../../home/presentation/quran_home_screen.dart';
import '../../../../newAyat/data/surah_index.dart';
import '../../../../newAyat/domain/redux/actions/actions.dart';
import '../../../domain/models/quran_answer.dart';
import '../../../domain/redux/actions/actions.dart';
import '../../quran_edit_answer_screen.dart';
import 'quran_answer_like_button_widget.dart';

class QuranAnswerActionControlWidget extends StatefulWidget {
  final QuranUser? currentUser;
  final int? questionId;
  final QuranAnswer answer;

  const QuranAnswerActionControlWidget({
    Key? key,
    required this.currentUser,
    required this.questionId,
    required this.answer,
  }) : super(key: key);

  @override
  State<QuranAnswerActionControlWidget> createState() =>
      _QuranAnswerActionControlWidgetState();
}

class _QuranAnswerActionControlWidgetState
    extends State<QuranAnswerActionControlWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          message: "Like",
          child: QuranAnswerLikeButtonWidget(
            numLikes: widget.answer.likedUsers.length,
            isLiked: widget.answer.likedUsers.contains(widget.currentUser?.uid),
            isLoading: _isLoading,
            isEnabled: _isLikeButtonEnable() ? true : false,
            onLikeTapped: () => _onLikeTapped(context),
          ),
        ),
        IconButton(
          tooltip: "Go to verse",
          onPressed: () => _onReadTapped(
            context,
            widget.answer,
          ),
          icon: const Icon(
            Icons.menu_book_rounded,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          tooltip: "Edit answer",
          onPressed: () => _isEditButtonEnable() ? _onEditTapped() : null,
          icon: Icon(
            Icons.edit_note,
            color: _isEditButtonEnable() ? Colors.blueGrey : Colors.black12,
          ),
        ),
        IconButton(
          tooltip: "Report problem with answer",
          onPressed: () => _onReportAnswerTapped(),
          icon: const Icon(
            Icons.report_problem_outlined,
            color: Colors.black12 ,
          ),
        ),
      ],
    );
  }

  /// BIZ LOGIC

  bool _isLikeButtonEnable() {
    // do not show like button if the answer was submitted by logged in user
    if (widget.currentUser?.uid == widget.answer.userId) {
      return false;
    }

    return true;
  }

  bool _isEditButtonEnable() {
    /// only allow to edit if answer is that of logged in user
    if (widget.currentUser?.uid != widget.answer.userId) {
      return false;
    }

    return true;
  }

  /// ACTIONS

  void _onLikeTapped(BuildContext context) {
    int? question = widget.questionId;
    if (question == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    bool isLiked = widget.answer.likedUsers.contains(widget.currentUser?.uid);
    Store<AppState> store = StoreProvider.of<AppState>(context);
    if (isLiked) {
      /// Unlike
      store.dispatch(UnlikeAnswerAction(
        questionId: question,
        answer: widget.answer,
      ));
    } else {
      /// Like
      store.dispatch(LikeAnswerAction(
        questionId: question,
        answer: widget.answer,
      ));
    }

    Future<void>.delayed(const Duration(milliseconds: 500)).then((value) => {
          setState(() {
            _isLoading = false;
          }),
        });
  }

  void _onReadTapped(
    BuildContext context,
    QuranAnswer answer,
  ) {
    {
      StoreProvider.of<AppState>(context).dispatch(
        SelectParticularAyaAction(
          index: SurahIndex(
            answer.surah,
            answer.aya,
          ),
        ),
      );
      StoreProvider.of<AppState>(context).dispatch(
        SelectHomeScreenTabAction(
          tab: QuranHomeScreenBottomTabsEnum.reader,
        ),
      );
    }
  }

  void _onEditTapped() {
    int? questionId = widget.questionId;
    if (questionId == null) {
      return;
    }
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranEditAnswerScreen(
          questionId: questionId,
          answer: widget.answer,
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  void _onReportAnswerTapped() {

  }
}
