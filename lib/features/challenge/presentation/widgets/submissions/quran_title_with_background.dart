import 'package:flutter/material.dart';

class QuranTitleWithBackground extends StatelessWidget {
  final String title;
  final Color? background;

  const QuranTitleWithBackground({
    super.key,
    required this.title,
    this.background = Colors.black12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: background,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                8,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
