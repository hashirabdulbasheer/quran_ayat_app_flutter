import 'package:flutter/material.dart';

class QuranAnswerLikeThumbsUpWidget extends StatelessWidget {
  final bool isLiked;
  final bool isEnabled;

  const QuranAnswerLikeThumbsUpWidget({
    Key? key,
    required this.isLiked,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEnabled) {
      /// Enabled state
      return isLiked
          ? const Icon(
              Icons.thumb_up,
              color: Colors.blueGrey,
              size: 24.0,
            )
          : const Icon(
              Icons.thumb_up_alt_outlined,
              color: Colors.blueGrey,
              size: 24.0,
            );
    } else {
      /// Disabled state
      return const Icon(
        Icons.thumb_up_alt_outlined,
        color: Colors.black12,
        size: 24.0,
      );
    }
  }
}
