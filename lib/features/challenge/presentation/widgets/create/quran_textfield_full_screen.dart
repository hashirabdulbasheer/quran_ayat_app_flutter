import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Hero(
      tag: 'imageHero',
      child: Directionality(
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
                  "save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: CupertinoTextField(
                      padding: const EdgeInsets.all(10),
                      controller: _controller..text = widget.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
