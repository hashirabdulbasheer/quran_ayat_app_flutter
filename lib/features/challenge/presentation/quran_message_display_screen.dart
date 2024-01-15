import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class QuranMessageDisplayScreen extends StatelessWidget {
  final String title;
  final String message;

  const QuranMessageDisplayScreen({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        /// APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),

        /// BODY
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              10,
            ),
            child: Markdown(
              data: message,
              styleSheet: MarkdownStyleSheet(textScaleFactor: 1.2,),
            ),
          ),
        ),
      ),
    );
  }
}
