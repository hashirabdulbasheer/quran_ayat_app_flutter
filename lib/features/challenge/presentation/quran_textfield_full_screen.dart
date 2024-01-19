import 'package:flutter/material.dart';

import 'widgets/create/quran_textfield_small_widget.dart';

class QuranFullTextFieldScreen extends StatefulWidget {
  final String title;
  final String text;

  const QuranFullTextFieldScreen({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  State<QuranFullTextFieldScreen> createState() =>
      _QuranFullTextFieldScreenState();
}

class _QuranFullTextFieldScreenState extends State<QuranFullTextFieldScreen> {
  final TextEditingController _controller = TextEditingController();

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
                Navigator.of(context).pop(_controller.text),
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
              child: QuranSmallTextFieldWidget(
                controller: _controller..text = widget.text,
                isEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
