import 'package:flutter/material.dart';

class QuranNotesCreateControlsWidget extends StatelessWidget {
  final Function onConfirmation;

  const QuranNotesCreateControlsWidget({
    super.key,
    required this.onConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => onConfirmation(),
              child: const Text("Save"),
            ),
          ),
        ),
      ],
    );
  }
}
