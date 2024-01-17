import 'package:flutter/material.dart';

class QuranAnswerLikeThumbsUpWidget extends StatelessWidget {
  final bool isLiked;

  const QuranAnswerLikeThumbsUpWidget({
    Key? key,
    required this.isLiked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLiked
        ? const Icon(
            Icons.thumb_up_alt_outlined,
            color: Colors.blueGrey,
            size: 24.0,
          )
        : const Icon(
            Icons.thumb_up,
            color: Colors.blueGrey,
            size: 24.0,
          );
  }
}
