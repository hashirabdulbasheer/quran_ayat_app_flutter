import 'package:flutter/material.dart';

import '../../../../../misc/design/design_system.dart';

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
          ? QuranDS.thumbsUpIconSelectedLarge
          : QuranDS.thumbsUpIconUnSelectedLarge;
    } else {
      /// Disabled state
      return QuranDS.thumbsUpIconDisabledLarge;
    }
  }
}
