import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/quran_action_progress_widget.dart';

/// two buttons in a row
/// negative button - red background, positive button - primary color
class QuranUpdateControlsWidget extends StatelessWidget {
  final String positiveActionText;
  final Function onPositiveAction;
  final bool? isPositiveActionRunning;

  final String negativeActionText;
  final Function onNegativeAction;
  final bool? isNegativeActionRunning;

  const QuranUpdateControlsWidget({
    Key? key,
    required this.positiveActionText,
    required this.onPositiveAction,
    this.isPositiveActionRunning = false,
    required this.negativeActionText,
    required this.onNegativeAction,
    this.isNegativeActionRunning = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => onPositiveAction(),
              child: isPositiveActionRunning == true
                  ? const QuranActionProgressIndicatorWidget()
                  : Text(positiveActionText),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => onNegativeAction(),
              child: isNegativeActionRunning == true
                  ? const QuranActionProgressIndicatorWidget()
                  : Text(negativeActionText),
            ),
          ),
        ),
      ],
    );
  }
}
