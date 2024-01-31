import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../../../misc/design/design_system.dart';
import '../../../../../models/qr_user_model.dart';
import '../../../../../utils/logger_utils.dart';
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
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.answer.likedUsers.contains(widget.currentUser?.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          message: "Like",
          child: QuranAnswerLikeButtonWidget(
            numLikes: widget.answer.likedUsers.length,
            isLiked: _isLiked,
            isLoading: false,
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
          icon: QuranDS.readIconColoured,
        ),
        IconButton(
          tooltip: "Edit answer",
          onPressed: () => _isEditButtonEnable() ? _onEditTapped() : null,
          icon: _isEditButtonEnable()
              ? QuranDS.editIconColoured
              : QuranDS.editIconDisabled,
        ),
        IconButton(
          tooltip: "Report problem with answer",
          onPressed: () => _onReportAnswerTapped(),
          icon: QuranDS.reportProblemDisabled,
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
    bool isLiked = widget.answer.likedUsers.contains(widget.currentUser?.uid);
    Store<AppState> store = StoreProvider.of<AppState>(context);
    if (isLiked) {
      setState(() {
        _isLiked = false;
      });

      /// Unlike
      store.dispatch(UnlikeAnswerAction(
        questionId: question,
        answer: widget.answer,
      ));
      QuranLogger.logAnalyticsWithParams(
        "answer-action-unlike",
        {
          'questionId': question,
          'answerId': widget.answer.id,
        },
      );
    } else {
      setState(() {
        _isLiked = true;
      });

      /// Like
      store.dispatch(LikeAnswerAction(
        questionId: question,
        answer: widget.answer,
      ));
      QuranLogger.logAnalyticsWithParams(
        "answer-action-like",
        {
          'questionId': question,
          'answerId': widget.answer.id,
        },
      );
    }
  }

  void _onReadTapped(
    BuildContext context,
    QuranAnswer answer,
  ) {
    Navigator.of(context).pop();
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
    QuranLogger.logAnalyticsWithParams(
      "answer-action-read",
      {
        'questionId': widget.questionId ?? -1,
        'answerId': widget.answer.id,
      },
    );
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
    QuranLogger.logAnalyticsWithParams(
      "answer-action-edit",
      {
        'questionId': questionId,
        'answerId': widget.answer.id,
      },
    );
  }

  void _onReportAnswerTapped() {
    QuranLogger.logAnalyticsWithParams(
      "answer-action-report",
      {
        'questionId': widget.questionId ?? -1,
        'answerId': widget.answer.id,
      },
    );
  }
}
