import 'package:ayat_app/src/core/extensions/widget_spacer_extension.dart';
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart';
import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:ayat_app/src/presentation/home/widgets/translation_display_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/word_by_word_aya_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
            return Column(
              children: [
                /// word by word
                const WordByWordAya(
                  words: [
                    QWord(word: 1, tr: "#######", aya: 1, sura: 1, ar: "######"),
                    QWord(word: 1, tr: "######", aya: 1, sura: 1, ar: "#######"),
                    QWord(word: 1, tr: "#######", aya: 1, sura: 1, ar: "######"),
                    QWord(word: 1, tr: "#######", aya: 1, sura: 1, ar: "######"),
                    QWord(word: 1, tr: "#######", aya: 1, sura: 1, ar: "######"),
                  ],
                  textScaleFactor: 1.0,
                ),

                /// translation
                const TranslationDisplay(
                  translation: "#############################################",
                  translationType: QTranslation.wahiduddinKhan,
                  textScaleFactor: 1,
                ),
              ].spacerDirectional(height: 10),
            );
          }),
        ),
      ),
    );
  }
}
