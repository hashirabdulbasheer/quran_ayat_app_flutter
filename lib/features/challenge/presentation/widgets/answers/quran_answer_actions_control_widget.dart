import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../domain/models/quran_answer.dart';
import '../../../domain/redux/actions/actions.dart';
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
        QuranAnswerLikeButtonWidget(
          numLikes: widget.answer.likedUsers.length,
          isLiked: widget.answer.likedUsers.contains(widget.currentUser?.uid),
          isLoading: _isLoading,
          onLikeTapped: () => _onLikeTapped(context),
        ),
      ],
    );
  }

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

    Future<void>.delayed(Duration(milliseconds: 500)).then((value) => {
          setState(() {
            _isLoading = false;
          }),
        });
  }
}
