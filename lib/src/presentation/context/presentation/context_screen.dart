import 'package:ayat_app/src/core/extensions/widget_spacer_extension.dart';
import 'package:ayat_app/src/domain/models/qword.dart';
import 'package:ayat_app/src/presentation/context/bloc/context_bloc.dart';
import 'package:ayat_app/src/presentation/home/widgets/arabic_text_widget.dart';
import 'package:ayat_app/src/presentation/home/widgets/text_row_widget.dart';
import 'package:ayat_app/src/presentation/widgets/base_screen.dart';
import 'package:ayat_app/src/presentation/widgets/scrollable_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContextScreen extends StatelessWidget {
  const ContextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContextBloc, ContextState>(builder: (context, state) {
      if (state is! ContextLoadedState) {
        return const Center(child: CircularProgressIndicator());
      }
      return QBaseScreen(
        title: state.title.transliterationEn,
        child: SafeArea(
          child: ScrollableListWidget(
              initialIndex: state.index.aya,
              itemsCount: state.data.translations.length, itemContent: (index) =>   ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${index + 1} ",
                  style: const TextStyle(fontSize: 12),
                ),
                ArabicText(
                  text: _ayaText(state.data.ayaWords, index),
                  textScaleFactor: state.textScale,
                ),
                // TODO: Considering only one translation for now
                TextRow(
                  text: state.data.translations[0].$2[index].text,
                  textScaleFactor: state.textScale,
                ),
              ].spacerDirectional(height: 10),
            ),
          ),),
        ),
      );
    });
  }

  String _ayaText(List<List<QWord>> words, int ayaIndex) {
    StringBuffer buffer = StringBuffer();
    List<QWord> ayaWords = words[ayaIndex];
    for (QWord word in ayaWords) {
      buffer.write(word.ar);
      buffer.write(" ");
    }

    return buffer.toString();
  }
}
