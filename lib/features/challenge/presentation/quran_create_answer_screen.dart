import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/features/newAyat/data/surah_index.dart';
import 'package:redux/redux.dart';

import '../../ayats/presentation/widgets/ayat_display_header_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_translation_widget.dart';
import '../../ayats/presentation/widgets/full_ayat_row_widget.dart';
import '../../core/domain/app_state/app_state.dart';

class QuranCreateChallengeScreen extends StatefulWidget {
  const QuranCreateChallengeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<QuranCreateChallengeScreen> createState() =>
      _QuranCreateChallengeScreenState();
}

class _QuranCreateChallengeScreenState
    extends State<QuranCreateChallengeScreen> {
  final TextEditingController _notesController = TextEditingController();
  NQSurahTitle currentSurahDetails = NQSurahTitle.defaultValue();
  SurahIndex? currentIndex;
  String note = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        /// APP BAR
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Submit Answer"),
        ),

        /// BODY
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              30,
              10,
              30,
              10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Select a verse that could answer the question",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(
                  height: 5,
                ),

                /// HEADER - AYA SELECTION
                QuranAyatHeaderWidget(
                  surahTitles: store.state.reader.surahTitles,
                  onSurahSelected: (surah) => setState(() => {
                        currentSurahDetails = surah,
                        currentIndex = SurahIndex(
                          surah.number - 1,
                          0,
                        ),
                      }),
                  onAyaNumberSelected: (aya) => setState(
                    () => currentIndex = SurahIndex(
                      currentSurahDetails.number - 1,
                      aya,
                    ),
                  ),
                  currentlySelectedSurah: currentSurahDetails,
                  currentIndex: currentIndex ?? SurahIndex.defaultIndex,
                ),
                const SizedBox(
                  height: 10,
                ),

                /// REST OF CONTENT
                currentIndex != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /// ARABIC + TRANSLATION
                          FutureBuilder<List<NQSurah>>(
                            future: Future.wait([
                              NobleQuran.getSurahArabic(
                                currentIndex!.sura,
                              ),
                              NobleQuran.getTranslationString(
                                currentIndex!.sura,
                                NQTranslation.wahiduddinkhan,
                              ),
                            ]),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<List<NQSurah>> snapshot,
                            ) {
                              final surah = snapshot.data;
                              if (surah == null || surah.length != 2) {
                                return const SizedBox();
                              }
                              NQSurah arabic = surah.first;
                              NQSurah translation = surah[1];

                              return Column(
                                children: [

                                  /// ARABIC AYA
                                  QuranFullAyatRowWidget(
                                    text: arabic.aya[currentIndex!.aya].text,
                                  ),

                                  /// TRANSLATION OF AYA
                                  QuranAyatDisplayTranslationWidget(
                                    translation: translation
                                            .aya[currentIndex!.aya].text ??
                                        "",
                                    translationType:
                                        NQTranslation.wahiduddinkhan,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// NOTES TEXT FIELD
                          const Text(
                            "Enter notes/reflection on how the verse answers the question",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              child: TextField(
                                controller: _notesController..text = note,
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
                          ),
                          const SizedBox(
                            height: 50,
                          ),

                          /// SUBMIT BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("Submit"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
