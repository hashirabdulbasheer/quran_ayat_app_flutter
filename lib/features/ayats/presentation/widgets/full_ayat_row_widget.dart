import 'package:noble_quran/models/surah.dart';
import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';

class QuranFullAyatRowWidget extends StatelessWidget {
  final Future<NQSurah>? futureMethodThatReturnsSelectedSurah;
  final int ayaIndex;
  final String? fontFamily;

  const QuranFullAyatRowWidget(
      {Key? key,
      required this.futureMethodThatReturnsSelectedSurah,
      required this.ayaIndex,
      this.fontFamily,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NQSurah>(
      future: futureMethodThatReturnsSelectedSurah,
      builder: (BuildContext context, AsyncSnapshot<NQSurah> snapshot,) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 100, child: Center(child: Text('Loading....')),),);
          default:
            if (snapshot.hasError) {
              return Container();
            } else {
              NQSurah surah = snapshot.data as NQSurah;
              List<NQAyat> ayats = surah.aya;

              return Card(
                elevation: 5,
                child: Directionality(
                  textDirection: QuranUtils.isArabic(ayats[ayaIndex - 1].text)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            _stripHtmlIfNeeded(ayats[ayaIndex - 1].text),
                            textAlign:
                                QuranUtils.isArabic(ayats[ayaIndex - 1].text)
                                    ? TextAlign.end
                                    : TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                fontFamily: fontFamily,
                                color: Colors.black87,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        }
      },
    );
  }

  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '',);
  }
}
