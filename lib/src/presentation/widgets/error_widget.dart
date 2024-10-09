import 'package:flutter/material.dart';

class QErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const QErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(message),
        IconButton(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh,
              size: 30,
            ))
      ],
    );
  }
}
