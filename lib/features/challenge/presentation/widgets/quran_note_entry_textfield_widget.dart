import 'package:flutter/material.dart';

class QuranNotesTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  const QuranNotesTextFieldWidget({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(0),
        child: TextField(
          controller: textEditingController..text,
          maxLines: 10,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
