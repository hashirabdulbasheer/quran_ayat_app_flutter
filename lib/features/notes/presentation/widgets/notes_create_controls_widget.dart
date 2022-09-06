import 'package:flutter/material.dart';

class QuranNotesCreateControlsWidget extends StatelessWidget {
  final Function onConfirmation;

  const QuranNotesCreateControlsWidget({
    Key? key,
    required this.onConfirmation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
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
      ),
    );
  }
}
