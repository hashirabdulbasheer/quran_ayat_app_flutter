import 'package:flutter/material.dart';

import '../../../../../models/qr_user_model.dart';
import '../../../domain/models/quran_answer.dart';
import 'quran_answer_like_button_widget.dart';

class QuranAnswerActionControlWidget extends StatelessWidget {
  final QuranUser? currentUser;
  final QuranAnswer answer;

  const QuranAnswerActionControlWidget({
    Key? key,
    required this.currentUser,
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
          onLikeTapped: () => _onLikeTapped(),
        ),
      ],
    );
  }

  void _onLikeTapped() {
      bool isLiked = answer.likedUsers.contains(currentUser?.uid);
      if(isLiked) {
        /// Unlike

      } else {
        /// Like
      }
  }
}
