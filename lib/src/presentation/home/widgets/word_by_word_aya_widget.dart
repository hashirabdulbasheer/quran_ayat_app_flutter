import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:ayat_app/src/presentation/home/widgets/word_by_word_widget.dart';
import 'package:flutter/material.dart';

class WordByWordAya extends StatelessWidget {
  final List<QWord> words;
  final double textScaleFactor;

  const WordByWordAya({
    super.key,
    required this.words,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.end,
              children: words
                  .map((e) => InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                            top: 10,
                          ),
                          child: WordByWord(
                            word: e,
                            textScaleFactor: textScaleFactor,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
