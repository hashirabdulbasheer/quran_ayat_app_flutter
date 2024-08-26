import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_ayat/features/core/domain/app_state/app_state.dart';

import '../../../misc/router/router_utils.dart';
import '../../challenge/domain/redux/actions/actions.dart';
import '../../home/presentation/quran_home_screen.dart';
import '../../newAyat/domain/redux/actions/actions.dart';
import '../../settings/domain/settings_manager.dart';
import '../domain/entities/quran_index.dart';
import '../domain/entities/quran_tag.dart';
import '../domain/entities/quran_tag_aya.dart';

class QuranResultsScreen extends StatefulWidget {
  final QuranTag tag;

  const QuranResultsScreen({
    super.key,
    required this.tag,
  });

  @override
  State<QuranResultsScreen> createState() => _QuranResultsScreenState();
}

class _QuranResultsScreenState extends State<QuranResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            List<QuranIndex>? indices = snapshot.data;
            if (indices == null) {
              return const Center(
                child: Text("No tags saved"),
              );
            }

            return ListView.separated(
              itemBuilder: (
                context,
                index,
              ) {
                return ListTile(
                  title: _listRow(indices[index]),
                  onTap: () => _onIndexTapped(indices[index]),
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
    );
  }

  Widget _listRow(
    QuranIndex index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${index.index.human.sura}: ${index.index.human.aya}",
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
    );
  }

  Future<List<QuranIndex>> _fetchDetails() async {
    List<QuranIndex> updatedIndices = [];
    List<NQTranslation> translations =
        await QuranSettingsManager.instance.getTranslations();
    for (QuranTagAya aya in widget.tag.ayas) {
      NQSurah translationSurah = await NobleQuran.getTranslationString(
        aya.index.sura,
        translations.first, // TODO: fix later to handle multiple translations
      );
      updatedIndices.add(QuranIndex(
        index: aya.index,
        surahTitle: translationSurah.name,
        translationAya: translationSurah.aya[aya.index.aya].text,
      ));
    }

    return updatedIndices;
  }

  _onIndexTapped(
    QuranIndex index,
  ) {
    StoreProvider.of<AppState>(context).dispatch(SelectParticularAyaAction(
      index: index.index,
    ));
    StoreProvider.of<AppState>(context).dispatch(
      SelectHomeScreenTabAction(
        tab: QuranHomeScreenBottomTabsEnum.reader,
      ),
    );
    QuranNavigator.of(context).routeToHome();
  }
}
