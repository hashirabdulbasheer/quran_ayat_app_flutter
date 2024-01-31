import 'package:flutter/material.dart';

import '../../../../misc/design/design_system.dart';

class QuranNormalProgressIndicatorWidget extends StatelessWidget {
  const QuranNormalProgressIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: QuranDS.primaryColor,
    );
  }
}
