import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'misc/enums/quran_font_family_enum.dart';
import 'models/qr_word_model.dart';
import 'utils/logger_utils.dart';
import 'utils/nav_utils.dart';
import 'utils/search_utils.dart';

class QuranSearchScreen extends StatefulWidget {
  final String? searchString;

  const QuranSearchScreen({
    Key? key,
    this.searchString,
  }) : super(key: key);

  @override
  QuranSearchScreenState createState() => QuranSearchScreenState();
}

class QuranSearchScreenState extends State<QuranSearchScreen> {
  static const int listeningTimeoutSecs = 5;

  final TextEditingController _searchController = TextEditingController();
  bool _isSpeechAvailable = false;
  String _enteredText = "";

  final StreamController<List<QuranWord>> _resultsController =
      StreamController<List<QuranWord>>.broadcast();

  final StreamController<String> _logController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    _initialize();
    String? searchStringParam = widget.searchString;
    if (searchStringParam != null && searchStringParam.isNotEmpty) {
      Future<void>.delayed(const Duration(milliseconds: 500)).then((value) {
        FocusManager.instance.primaryFocus?.unfocus();
        _enteredText = searchStringParam;
        _searchController.text = _enteredText;
        _search(_enteredText);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _resultsController.close();
    _logController.close();
    stt.SpeechToText speech = stt.SpeechToText();
    speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(title: const Text("Quran Search")),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<QuranWord>>(
                stream: _resultsController.stream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<QuranWord>> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return Expanded(
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (snapshot.hasData) {
                    List<QuranWord> words = snapshot.data as List<QuranWord>;
                    if (words.isNotEmpty) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            10,
                          ),
                          child: ListView.separated(
                            reverse: true,
                            separatorBuilder: (
                              context,
                              index,
                            ) {
                              return const Divider(thickness: 1);
                            },
                            itemCount: words.length,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return ListTile(
                                onTap: () => _onSearchResultTileTapped(
                                  context,
                                  words,
                                  index,
                                ),
                                title: Column(children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          words[index].word.ar,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: QuranFontFamily
                                                .arabic.rawString,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            words[index].word.tr,
                                            style: const TextStyle(
                                              fontSize: 25,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          "${words[index].word.sura}:${words[index].word.aya}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  }

                  return Container();
                },
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Divider(thickness: 0.5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        0,
                      ),
                      child: Row(
                        children: [
                          StreamBuilder<String>(
                            stream: _logController.stream,
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<String> snapshot,
                            ) {
                              if (snapshot.hasData) {
                                return Wrap(
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(snapshot.data ?? ""),
                                    ),
                                  ],
                                );
                              }

                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          10,
                          20,
                          0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.right,
                                autofocus: true,
                                style: TextStyle(fontSize: 25, fontFamily: QuranFontFamily.arabic.rawString,),
                                textDirection: TextDirection.rtl,
                                onSubmitted: (value) =>
                                    _onSearchTextFieldSubmitted(value),
                                decoration: InputDecoration(
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _startListening(),
                                        icon: const Icon(Icons.mic),
                                      ),
                                      IconButton(
                                        onPressed: () => _clear(),
                                        icon: const Icon(Icons.clear),
                                      ),
                                      IconButton(
                                        onPressed: () => _onSearchIconPressed(),
                                        icon: const Icon(Icons.send),
                                      ),
                                    ],
                                  ),
                                  hintText: "input a word",
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                      width: 0.0,
                                    ),
                                  ),
                                ),
                                controller: _searchController
                                  ..text = _enteredText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchResultTileTapped(
    BuildContext context,
    List<QuranWord> words,
    int index,
  ) {
    QuranNavigator.navigateToAyatScreen(
      context,
      surahIndex: words[index].word.sura - 1,
      ayaIndex: words[index].word.aya,
    );
  }

  void _onSearchTextFieldSubmitted(String value) {
    if (value.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      _search(value);
    }
  }

  void _onSearchIconPressed() {
    if (_searchController.text.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      _search(_searchController.text);
    }
  }

  /// Clear
  void _clear({bool clearLog = true}) {
    setState(() {
      _enteredText = "";
      _searchController.clear();
    });
    _resultsController.sink.add([]);
    if (clearLog) {
      _log("Search a word");
    }
  }

  /// display log message
  void _log(String message) {
    _logController.sink.add(message);
    _logController.done;
  }

  /// search part 1
  void _search(String enteredText) async {
    _log("Searching  $enteredText  ");
    List<QuranWord> results = [];
    if (kIsWeb) {
      /// web
      await Future<void>.delayed(const Duration(seconds: 1));
      results = await compute(
        QuranSearch.searchStep2,
        enteredText,
      );
    } else {
      /// mobile devices - use isolate spawn
      final p = ReceivePort();
      await Isolate.spawn(
        QuranSearch.searchBackgroundForDevice,
        [
          p.sendPort,
          enteredText,
          QuranSearch.globalQRWords,
        ],
      );
      results = await p.first as List<QuranWord>;
    }
    _resultsController.sink.add(results);
    _resultsController.done;
    _log("Searching  $enteredText ... Found ${results.length}");
    QuranLogger.logAnalytics("search");
  }

  Future<bool> _onWillPop() async {
    if (_enteredText.isEmpty) {
      return true;
    }
    _clear();

    return false;
  }

  ///
  /// Speech methods
  ///

  /// initialize
  Future<void> _initialize() async {
    stt.SpeechToText speech = stt.SpeechToText();
    _isSpeechAvailable = await speech.initialize(
      onStatus: (status) {
        // print(status);
      },
      onError: (error) {
        QuranLogger.logE(error);
      },
    );
    _log("Search a word");
  }

  /// start listening
  Future<void> _startListening() async {
    if (_isSpeechAvailable) {
      _log("Listening started");
      stt.SpeechToText speech = stt.SpeechToText();
      if (speech.isListening) {
        // already listening
        return;
      }
      // reset everything
      _clear(clearLog: false);
      // start listening
      speech.listen(
        onResult: (result) {
          // results obtained
          _enteredText = result.recognizedWords;
          _searchController.text = _enteredText;
          _search(_enteredText);
        },
        localeId: "ar",
      );
      // some time later...
      Future<void>.delayed(const Duration(seconds: listeningTimeoutSecs))
          .then((value) {
        _log("Listening stopped");
        speech.stop();
      });
    } else {
      _log("The user has denied the use of speech recognition.");
    }
  }
}
