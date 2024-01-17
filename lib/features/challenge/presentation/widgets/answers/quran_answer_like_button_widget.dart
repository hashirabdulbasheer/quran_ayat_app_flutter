import 'package:flutter/material.dart';

import 'quran_answer_like_thumbs_up_widget.dart';

class QuranAnswerLikeButtonWidget extends StatelessWidget {
  final int numLikes;
  final bool isLiked;
  final bool isLoading;
  final Function onLikeTapped;

  const QuranAnswerLikeButtonWidget({
    Key? key,
    required this.numLikes,
    required this.isLiked,
    required this.isLoading,
    required this.onLikeTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextButton(
        onPressed: () => onTappedAction(),
        child: Row(
          children: [
            /// Icon
            QuranAnswerLikeThumbsUpWidget(
              isLiked: isLiked,
            ),

            const SizedBox(
              width: 10,
            ),

            if (isLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueGrey,
                  ),
                ),
              ),

            /// Label with count
            if (!isLoading)
              numLikes > 0
                  ? Text(
                      "($numLikes)",
                      style: const TextStyle(fontSize: 12),
                    )
                  : const Text(""),
          ],
        ),
      ),
    );
  }

  void onTappedAction() {
    if (!isLoading) {
      onLikeTapped();
    }
  }
}
