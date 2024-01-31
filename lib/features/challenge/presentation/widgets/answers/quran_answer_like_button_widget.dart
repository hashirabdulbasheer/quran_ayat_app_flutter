import 'package:flutter/material.dart';

import '../../../../../misc/design/design_system.dart';
import '../../../../core/presentation/widgets/quran_normal_progress_widget.dart';
import 'quran_answer_like_thumbs_up_widget.dart';

class QuranAnswerLikeButtonWidget extends StatelessWidget {
  final int numLikes;
  final bool isLiked;
  final bool isLoading;
  final bool isEnabled;
  final Function onLikeTapped;

  const QuranAnswerLikeButtonWidget({
    Key? key,
    required this.numLikes,
    required this.isLiked,
    required this.isLoading,
    required this.isEnabled,
    required this.onLikeTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: TextButton(
        onPressed: () => isEnabled ? onTappedAction() : null,
        child: Row(
          children: [
            /// Icon
            QuranAnswerLikeThumbsUpWidget(
              isLiked: isLiked,
              isEnabled: isEnabled,
            ),

            const SizedBox(
              width: 10,
            ),

            if (isLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: QuranNormalProgressIndicatorWidget(),
                ),
              ),

            /// Label with count
            if (!isLoading)
              numLikes > 0
                  ? Text(
                      "($numLikes)",
                      style: QuranDS.textTitleSmall,
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
