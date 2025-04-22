import 'dart:async';

import 'package:ayat_app/src/presentation/home/home.dart';

class WordByWordAya extends StatefulWidget {
  final List<QWord> words;
  final double textScaleFactor;

  const WordByWordAya({
    super.key,
    required this.words,
    this.textScaleFactor = 1.0,
  });

  @override
  State<WordByWordAya> createState() => _WordByWordAyaState();
}

class _WordByWordAyaState extends State<WordByWordAya> {
  late List<bool> _showTranslations;
  final Map<int, Timer> _timers = {};
  static const _wordTranslationDisplayTimeSecs = 3;

  @override
  void initState() {
    super.initState();
    _showTranslations = List.generate(widget.words.length, (_) => false);
  }

  void _toggleTranslationTemporarily(int index) {
    // Cancel any existing timer for this word
    _timers[index]?.cancel();

    setState(() {
      _showTranslations[index] = true;
    });

    // Set timer to hide after x seconds
    _timers[index] =
        Timer(const Duration(seconds: _wordTranslationDisplayTimeSecs), () {
      if (mounted) {
        setState(() {
          _showTranslations[index] = false;
        });
      }
    });
  }

  @override
  void dispose() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.end,
              children: widget.words.asMap().entries.map((entry) {
                int index = entry.key;
                QWord word = entry.value;
                return InkWell(
                  onTap: () => _toggleTranslationTemporarily(index),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                      top: 10,
                    ),
                    child: WordByWord(
                      word: word,
                      isTranslationDisplayed: _showTranslations[index],
                      textScaleFactor: widget.textScaleFactor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
