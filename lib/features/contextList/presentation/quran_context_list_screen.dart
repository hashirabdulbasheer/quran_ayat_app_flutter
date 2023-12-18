import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/word.dart';

import '../../../misc/enums/quran_font_family_enum.dart';
import '../../ayats/presentation/widgets/font_scaler_widget.dart';
import '../../core/domain/app_state/app_state.dart';
import '../../newAyat/data/surah_index.dart';
import 'widgets/list_widget.dart';

class QuranContextListScreen extends StatefulWidget {
  final String title;
  final SurahIndex index;

  const QuranContextListScreen({
    Key? key,
    required this.title,
    required this.index,
  }) : super(key: key);

  @override
  State<QuranContextListScreen> createState() => _QuranContextListScreenState();
}

class _QuranContextListScreenState extends State<QuranContextListScreen> {
  NQSurah? _translation;
  List<List<NQWord>>? _wordsList;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _list(),
      ),
    );
  }

  Widget _list() {
    _translation = StoreProvider.of<AppState>(context).state.reader.data.firstTranslation();
    _wordsList = StoreProvider.of<AppState>(context).state.reader.data.words;

    return SafeArea(
      maintainBottomViewPadding: true,
      minimum: const EdgeInsets.fromLTRB(0, 10, 0, 20,),
      child: ListWidget(
        initialIndex: widget.index.aya,
        itemsCount: _translation?.aya.length ?? 0,
        itemContent: (index) => QuranFontScalerWidget(
          body: (
            context,
            fontScale,
          ) =>
              _listItemBody(
            index,
            fontScale,
          ),
        ),
      ),
    );
  }

  Widget _listItemBody(
    int index,
    double fontScale,
  ) {
    return ListTile(
      onTap: () => _onListTileTap(index),
      style: null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1} ",
            textScaleFactor: fontScale,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.color
                  ?.withOpacity(0.5),
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
                    _ayaText(index),
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

  String _ayaText(int ayaIndex) {
    StringBuffer buffer = StringBuffer();
    List<NQWord> words = _wordsList?[ayaIndex] ?? [];
    for (NQWord word in words) {
      buffer.write(word.ar);
      buffer.write(" ");
    }

    return buffer.toString();
  }

  void _onListTileTap(int index) {
    Navigator.pop(
      context,
      index,
    );
  }
}
