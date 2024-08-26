import 'package:flutter/material.dart';

import '../../../../../misc/design/design_system.dart';

class QuranAnswerLikeThumbsUpWidget extends StatelessWidget {
  final bool isLiked;
  final bool isEnabled;

  const QuranAnswerLikeThumbsUpWidget({
    super.key,
    required this.isLiked,
    required this.isEnabled,
  });

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
