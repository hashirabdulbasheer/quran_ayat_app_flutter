import 'package:flutter/material.dart';

import '../../../../misc/design/design_system.dart';

class QuranNormalProgressIndicatorWidget extends StatelessWidget {
  const QuranNormalProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: QuranDS.primaryColor,
    );
  }
}
