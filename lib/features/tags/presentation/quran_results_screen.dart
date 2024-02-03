import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/noble_quran.dart';

import '../../../utils/logger_utils.dart';
import '../../settings/domain/settings_manager.dart';
import '../domain/entities/quran_index.dart';
import '../domain/entities/quran_tag.dart';
import '../domain/entities/quran_tag_aya.dart';

class QuranResultsScreen extends StatefulWidget {
  final QuranTag tag;

  const QuranResultsScreen({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  State<QuranResultsScreen> createState() => _QuranResultsScreenState();
}

class _QuranResultsScreenState extends State<QuranResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tags"),
        ),
        body: FutureBuilder<List<QuranIndex>>(
          future: _fetchDetails(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<QuranIndex>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text('Loading....'),
                ),
              );
            } else {
              List<QuranIndex> indices = snapshot.data as List<QuranIndex>;

              return ListView.separated(
                itemBuilder: (
                  context,
                  index,
                ) {
                  return ListTile(
                    title: _listRow(indices[index]),
                    onTap: () => {
                      // TODO: Fix navigation to ayat screen
                      QuranLogger.log("Not implemented"),
                    },
                  );
                },
                separatorBuilder: (
                  context,
                  index,
                ) {
                  return const Divider(thickness: 1);
                },
                itemCount: indices.length,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _listRow(
    QuranIndex index,
  ) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${index.surahIndex}: ${index.ayaIndex}",
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              Text(
                index.surahTitle ?? "",
                style: const TextStyle(
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(index.translationAya ?? ""),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<List<QuranIndex>> _fetchDetails() async {
    List<QuranIndex> updatedIndices = [];
    for (QuranTagAya aya in widget.tag.ayas) {
      List<NQTranslation> translations =
          await QuranSettingsManager.instance.getTranslations();
      NQSurah translationSurah = await NobleQuran.getTranslationString(
        aya.suraIndex - 1,
        translations.first, // TODO: fix later to handle multiple translations
      );
      updatedIndices.add(QuranIndex(
        surahIndex: aya.suraIndex,
        ayaIndex: aya.ayaIndex,
        surahTitle: translationSurah.name,
        translationAya: translationSurah.aya[aya.ayaIndex - 1].text,
      ));
    }

    return updatedIndices;
  }
}
