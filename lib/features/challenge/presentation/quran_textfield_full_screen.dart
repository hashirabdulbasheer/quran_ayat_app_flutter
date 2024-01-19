import 'package:flutter/material.dart';

import 'widgets/create/quran_note_entry_textfield_widget.dart';

class QuranFullTextFieldScreen extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const QuranFullTextFieldScreen({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  State<QuranFullTextFieldScreen> createState() =>
      _QuranFullTextFieldScreenState();
}

class _QuranFullTextFieldScreenState extends State<QuranFullTextFieldScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(widget.controller.text),
              },
              child: const Text(
                "SAVE",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: QuranNotesTextFieldWidget(
                textEditingController: widget.controller,
                title: "",
                isEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
