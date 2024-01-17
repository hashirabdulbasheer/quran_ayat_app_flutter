import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../../core/domain/app_state/app_state.dart';
import '../../../domain/models/quran_answer.dart';
import '../../../domain/redux/actions/actions.dart';
import 'quran_answer_like_button_widget.dart';

class QuranAnswerActionControlWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuranAnswerLikeButtonWidget(
          numLikes: answer.likedUsers.length,
          isLiked: answer.likedUsers.contains(currentUser?.uid),
          isLoading: false,
          onLikeTapped: () => _onLikeTapped(context),
        ),
      ],
    );
  }

  void _onLikeTapped(BuildContext context) {
    int? question = questionId;
    if (question == null) {
      return;
    }
    bool isLiked = answer.likedUsers.contains(currentUser?.uid);
    Store<AppState> store = StoreProvider.of<AppState>(context);
    if (isLiked) {
      /// Unlike
      store.dispatch(UnlikeAnswerAction(
        questionId: question,
        answer: answer,
      ));
    } else {
      /// Like
      store.dispatch(LikeAnswerAction(
        questionId: question,
        answer: answer,
      ));
    }

    store.dispatch(InitializeChallengeScreenAction(questions: const []));
  }
}
