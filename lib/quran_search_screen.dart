import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import 'main.dart';
import 'models/qr_word_model.dart';
import 'utils/utils.dart';

class QuranSearchScreen extends StatefulWidget {
  const QuranSearchScreen({Key? key}) : super(key: key);

  @override
  QuranSearchScreenState createState() => QuranSearchScreenState();
}

class QuranSearchScreenState extends State<QuranSearchScreen> {
  static const int listeningTimeoutSecs = 5;
  static const int watchDogTimeoutSecs = 2;

  final TextEditingController _searchController = TextEditingController();
  bool _isSpeechAvailable = false;
  String _enteredText = "";

  final StreamController<List<QuranWord>> _resultsController =
      StreamController<List<QuranWord>>.broadcast();

  final StreamController<String> _logController = StreamController<String>.broadcast();

  Timer? _watchDogTimer;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _resultsController.close();
    _logController.close();
    _watchDogTimer?.cancel();
    stt.SpeechToText speech = stt.SpeechToText();
    speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quran Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        textAlign: TextAlign.right,
                        autofocus: true,
                        textDirection: TextDirection.rtl,
                        onChanged: (value) => _search(value),
                        decoration: InputDecoration(
                            labelText: "Search a word",
                            suffixIcon: IconButton(
                                onPressed: () => _clear(), icon: const Icon(Icons.clear)),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.0),
                            )),
                        controller: _searchController..text = _enteredText),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => _startListening(), child: const Icon(Icons.mic)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: Row(
              children: [
                StreamBuilder<String>(
                    stream: _logController.stream,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Wrap(
                          children: [
                            Text(snapshot.data ?? ""),
                          ],
                        );
                      }
                      return Container();
                    }),
              ],
            ),
          ),
          const Divider(),
          StreamBuilder<List<QuranWord>>(
              stream: _resultsController.stream,
              builder: (BuildContext context, AsyncSnapshot<List<QuranWord>> snapshot) {
                if (snapshot.hasError) {
                  return Expanded(child: Center(child: Text('Error: ${snapshot.error}')));
                } else if (snapshot.hasData) {
                  List<QuranWord> words = snapshot.data as List<QuranWord>;
                  if (words.isNotEmpty) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: words.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Column(children: [
                                Row(
                                  children: [Expanded(child: Text(words[index].word.ar))],
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
                                              textAlign: TextAlign.right,
                                            )))
                                  ],
                                ),
                              ]));
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Expanded(child: Center(child: Text("Waiting")));
                  }
                } else {
                  return const Expanded(child: Center(child: Text("Waiting")));
                }
              })
        ],
      ),
    );
  }

  /// Clear
  _clear({bool clearLog = true}) {
    setState(() {
      _enteredText = "";
      _searchController.clear();
    });
    _resultsController.sink.add([]);
    if (clearLog) {
      _log("");
    }
  }

  /// display log message
  _log(String message) {
    _logController.sink.add(message);
    _logController.done;
  }

  /// search part 1
  _search(String enteredText) {
    if (enteredText.length > 2) {
      _watchDogTimer?.cancel();
      _watchDogTimer = Timer(const Duration(seconds: watchDogTimeoutSecs), () {
        List<String> words = enteredText.split(" ");
        if (words.length > 1) {
          _searchStep2(words[0]);
        } else {
          _searchStep2(enteredText);
        }
      });
    }
  }

  /// search part 2
  _searchStep2(String enteredText) {
    _log("Searching $enteredText");
    Future.delayed(const Duration(seconds: 1)).then((value) {
      List<QuranWord> results = qrWords
          .where((element) {
            String normalizedWord = QuranUtils.normalise(element.ar);
            String normalizedEntered = QuranUtils.normalise(enteredText);
            return normalizedWord.similarityTo(normalizedEntered) > 0.5;
          })
          .toList()
          .map((e) {
            String normalizedWord = QuranUtils.normalise(e.ar);
            String normalizedEntered = QuranUtils.normalise(enteredText);
            double score = normalizedWord.similarityTo(normalizedEntered);
            return QuranWord(word: e, similarityScore: score);
          })
          .toList();
      results.sort((QuranWord a, QuranWord b) => b.similarityScore.compareTo(a.similarityScore));
      _resultsController.sink.add(results);
      _resultsController.done;
      _log("Searching $enteredText ... Found ${results.length}");
    });
  }

  /// initialize
  Future<void> _initialize() async {
    stt.SpeechToText speech = stt.SpeechToText();
    _isSpeechAvailable = await speech.initialize(onStatus: (status) {
      // print(status);
    }, onError: (error) {
      print(error);
    });
    _log("Click record button for voice search or type");
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
      Future.delayed(const Duration(seconds: listeningTimeoutSecs)).then((value) {
        _log("Listening stopped");
        speech.stop();
      });
    } else {
      _log("The user has denied the use of speech recognition.");
    }
  }
}
