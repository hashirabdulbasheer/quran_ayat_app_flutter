import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/noble_quran.dart';
import '../../../misc/enums/quran_font_family_enum.dart';
import 'widgets/list_widget.dart';
import '../../settings/domain/settings_manager.dart';

class QuranContextListScreen extends StatefulWidget {
  final String title;
  final int surahIndex;
  final int ayaIndex;

  const QuranContextListScreen({
    Key? key,
    required this.title,
    required this.surahIndex,
    required this.ayaIndex,
  }) : super(key: key);

  @override
  State<QuranContextListScreen> createState() => _QuranContextListScreenState();
}

class _QuranContextListScreenState extends State<QuranContextListScreen> {
  NQSurah? _arabic;
  NQSurah? _translation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<bool>(
        future: _fetchSurah(),
        builder: (
          BuildContext context,
          AsyncSnapshot<bool> snapshot,
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
            return _list();
          }
        },
      ),
    );
  }

  Widget _list() {
    return ListWidget(
      initialAyaIndex: widget.ayaIndex-1,
      itemsCount: _arabic?.aya.length ?? 0,
      itemContent: _listItem,
    );
  }

  Widget _listItem(int index, double fontScale,) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1} ",
            textScaleFactor: fontScale,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.titleSmall?.color?.withOpacity(0.5),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    _arabic?.aya[index].text ?? "",
                    textScaleFactor: fontScale,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: QuranFontFamily.arabic.rawString,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            _translation?.aya[index].text ?? "",
            textScaleFactor: fontScale,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _fetchSurah() async {
    _arabic = await NobleQuran.getSurahArabic(widget.surahIndex);
    NQTranslation currentTranslation =
        await QuranSettingsManager.instance.getTranslation();
    _translation = await NobleQuran.getTranslationString(
      widget.surahIndex,
      currentTranslation,
    );

    return true;
  }
}
