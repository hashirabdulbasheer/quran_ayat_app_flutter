import 'package:flutter/material.dart';

import '../../../settings/domain/settings_manager.dart';

class QuranFontScalerWidget extends StatelessWidget {
  final Widget Function(
    BuildContext,
    double,
  ) body;

  const QuranFontScalerWidget({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: QuranSettingsManager.instance.getFontScale(),
      builder: (
        BuildContext context,
        AsyncSnapshot<double> snapshot,
      ) {
        double fontScale = 1;
        if (!snapshot.hasError && snapshot.data != null) {
          fontScale = snapshot.data as double;
        }

        return body(
          context,
          fontScale,
        );
      },
    );
  }
}
