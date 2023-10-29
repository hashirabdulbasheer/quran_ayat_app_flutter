import 'package:flutter/material.dart';
import 'package:noble_quran/models/word.dart';

import '../../../../misc/constants/string_constants.dart';
import '../../../../misc/enums/quran_font_family_enum.dart';
import '../../../../quran_search_screen.dart';
import 'font_scaler_widget.dart';

class QuranAyatDisplayWordByWordWidget extends StatelessWidget {
  final List<NQWord> words;
  final ValueNotifier<bool> continuousMode;

  const QuranAyatDisplayWordByWordWidget({
    Key? key,
    required this.words,
    required this.continuousMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuranFontScalerWidget(body: _body);
  }

  Widget _body(BuildContext context, double fontScale,) {
    return Semantics(
      enabled: true,
      excludeSemantics: false,
      label: "quran ayat display with meaning",
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.end,
                  children: words
                      .map((e) => Semantics(
                            enabled: true,
                            excludeSemantics: true,
                            container: true,
                            child: Tooltip(
                              message: '${e.ar} ${e.tr}',
                              child: InkWell(
                                onTap: ()  {
                                  // TODO: Fix navigation to search
                                  // if (_isInteractionAllowedOnScreen())
                                  //   {
                                  //     Navigator.push<void>(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             QuranSearchScreen(
                                  //           searchString: e.ar,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   }
                                  // else
                                  //   {
                                  //     _showMessage(
                                  //       context,
                                  //       QuranStrings.contPlayMessage,
                                  //     ),
                                  //   },
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Text(
                                          e.ar,
                                          softWrap: false,
                                          maxLines: 1,
                                          textScaleFactor: fontScale,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontFamily: QuranFontFamily
                                                .arabic.rawString,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          border: Border.fromBorderSide(
                                            BorderSide(color: Colors.black26),
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(1),
                                          ),
                                        ),
                                        child: Text(
                                          e.tr,
                                          textScaleFactor: fontScale,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isInteractionAllowedOnScreen() {
    // disable all interactions if continuous play mode is on
    return !continuousMode.value;
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
