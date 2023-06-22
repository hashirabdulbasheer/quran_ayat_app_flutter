import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/features/tags/domain/entities/quran_master_tag_aya.dart';
import '../../settings/domain/settings_manager.dart';
import '../domain/entities/quran_index.dart';
import '../domain/entities/quran_master_tag.dart';

class QuranResultsScreen extends StatefulWidget {
  final QuranMasterTag tag;

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
                    onTap: () {
                      print("asds");
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
              Text("${index.surahIndex}: ${index.ayaIndex}"),
              Text(index.surahTitle ?? "n/a"),
            ],
          ),
          Text(index.translationAya ?? ""),
        ],
      ),
    );
  }

  Future<List<QuranIndex>> _fetchDetails() async {
    List<QuranIndex> updatedIndices = [];
    for (QuranMasterTagAya aya in widget.tag.ayas) {
      NQTranslation translation =
          await QuranSettingsManager.instance.getTranslation();
      NQSurah translationSurah = await NobleQuran.getTranslationString(
        aya.suraIndex - 1,
        translation,
      );
      updatedIndices.add(QuranIndex(
        surahIndex: aya.suraIndex,
        ayaIndex: aya.ayaIndex,
        surahTitle: translationSurah.name,
        translationAya: translationSurah.aya[aya.ayaIndex].text,
      ));
    }

    return updatedIndices;
  }
}
