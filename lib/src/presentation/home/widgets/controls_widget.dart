import 'package:flutter/material.dart';

class DisplayControls extends StatelessWidget {
  final VoidCallback onContextPressed;
  final VoidCallback onTextSizeIncreasePressed;
  final VoidCallback onTextSizeDecreasePressed;
  final VoidCallback onTextSizeResetPressed;
  final VoidCallback onPreviousPagePressed;

  const DisplayControls({
    super.key,
    required this.onContextPressed,
    required this.onTextSizeIncreasePressed,
    required this.onTextSizeDecreasePressed,
    required this.onTextSizeResetPressed,
    required this.onPreviousPagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          tooltip: "Increase font size",
          onPressed: onTextSizeIncreasePressed,
          icon: const Icon(Icons.add, size: 15),
        ),
        IconButton(
          tooltip: "Decrease font size",
          onPressed: onTextSizeDecreasePressed,
          icon: const Icon(Icons.remove, size: 15),
        ),
        IconButton(
          tooltip: "Reset font size",
          onPressed: onTextSizeResetPressed,
          icon: const Icon(Icons.refresh, size: 15),
        ),
        const Spacer(),
        IconButton(
          tooltip: "Back to previous page",
          onPressed: onPreviousPagePressed,
          icon: const Icon(Icons.arrow_forward, size: 20),
        ),
      ],
    );
  }
}
