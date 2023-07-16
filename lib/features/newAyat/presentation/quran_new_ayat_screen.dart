import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:redux/redux.dart';

import '../../ayats/domain/enums/audio_events_enum.dart';
import '../../ayats/presentation/widgets/ayat_display_audio_controls_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_header_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_surah_progress_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_translation_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_transliteration_widget.dart';
import '../../ayats/presentation/widgets/ayat_display_word_by_word_widget.dart';
import '../../contextList/presentation/quran_context_list_screen.dart';
import '../../core/domain/app_state/app_state.dart';
import '../domain/redux/actions/actions.dart';

class QuranNewAyatScreen extends StatelessWidget {
  const QuranNewAyatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // drawer: null,
        // onDrawerChanged: null,
        // bottomSheet: Container(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Quran"),
        ),
        body: StoreBuilder<AppState>(
          builder: (
            BuildContext context,
            Store<AppState> store,
          ) {
            int currentSurah = store.state.reader.currentSurah;
            int currentAyah = store.state.reader.currentAya;
            NQSurahTitle currentSurahDetails =
                store.state.reader.currentSurahDetails();

            return Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                10,
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// header
                  QuranAyatHeaderWidget(
                    surahTitles: store.state.reader.surahTitles,
                    onSurahSelected: (surah) => store
                        .dispatch(SelectSurahAction(surah: surah.number)),
                    onAyaNumberSelected: (aya) =>
                        store.dispatch(SelectAyaAction(aya: aya)),
                    continuousMode: ValueNotifier(false),
                    currentlySelectedSurah: currentSurahDetails,
                    currentlySelectedAya: currentAyah,
                  ),

                  /// surah progress
                  QuranAyatDisplaySurahProgressWidget(
                    currentlySelectedSurah: currentSurahDetails,
                    currentlySelectedAya: currentAyah,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => _navigateToContextListScreen(
                            store,
                            context,
                          ),
                          icon: const Icon(
                            Icons.list_alt,
                            size: 15,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _incrementFontSize(store),
                          icon: const Icon(
                            Icons.add,
                            size: 15,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _decrementFontSize(store),
                          icon: const Icon(
                            Icons.remove,
                            size: 15,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _resetFontSize(store),
                          icon: const Icon(
                            Icons.refresh,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// body
                  Card(
                    elevation: 5,
                    child: FutureBuilder<List<List<NQWord>>>(
                      future: NobleQuran.getSurahWordByWord(
                        currentSurah,
                      ),
                      // async work
                      builder: (
                          BuildContext context,
                          AsyncSnapshot<List<List<NQWord>>> snapshot,
                          ) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SizedBox(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: Text('Loading....'),
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              List<List<NQWord>> surahWords =
                              snapshot.data as List<List<NQWord>>;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: QuranAyatDisplayWordByWordWidget(
                                  words: surahWords[currentAyah - 1],
                                  continuousMode: ValueNotifier(false),
                                ),
                              );
                            }
                        }
                      },
                    ),
                  ),

                  /// transliterationWidget if enabled
                  QuranAyatDisplayTransliterationWidget(
                    currentlySelectedSurah: currentSurahDetails,
                    currentlySelectedAya: currentAyah,
                  ),

                  /// translation widget
                  QuranAyatDisplayTranslationWidget(
                    currentlySelectedSurah: currentSurahDetails,
                    currentlySelectedAya: currentAyah,
                  ),

                  /// audio controls
                  QuranAyatDisplayAudioControlsWidget(
                    currentlySelectedSurah: currentSurahDetails,
                    currentlySelectedAya: currentAyah,
                    onAudioPlayStatusChanged:
                        (event)  => _onAudioPlayStatusChanged(event, store,),
                    continuousMode: ValueNotifier(store.state.reader.isAudioContinuousModeEnabled),
                  ),
/*
                        /// Tags
                        StoreBuilder<AppState>(
                          onDidChange: (old,
                              updated,) =>
                              _onStoreDidChange(),
                          builder: (BuildContext context,
                              Store<AppState> store,) =>
                              QuranAyatDisplayTagsWidget(
                                currentlySelectedSurah: _selectedSurah,
                                ayaIndex: _selectedAyat,
                                continuousMode: _isAudioContinuousModeEnabled,
                              ),
                        ),

                        /// Notes
                        StoreBuilder<AppState>(
                          builder: (BuildContext context,
                              Store<AppState> store,) =>
                              QuranAyatDisplayNotesWidget(
                                currentlySelectedSurah: _selectedSurah,
                                currentlySelectedAya: _selectedAyat,
                                continuousMode: _isAudioContinuousModeEnabled,
                              ),
                        ),

                        const SizedBox(height: 30),
 */
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToContextListScreen(
    Store<AppState> store,
    BuildContext context,
  ) async {
    int? selectedAyaIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => QuranContextListScreen(
          title: store.state.reader.currentSurahDetails().transliterationEn,
          surahIndex: store.state.reader.currentSurahDetails().number - 1,
          ayaIndex: store.state.reader.currentAya,
        ),
      ),
    );

    if (selectedAyaIndex != null) {
      store.dispatch(SelectAyaAction(aya: selectedAyaIndex));
    }
  }

  void _incrementFontSize(
    Store<AppState> store,
  ) {
    store.dispatch(IncreaseFontSizeAction());
  }

  void _decrementFontSize(
    Store<AppState> store,
  ) {
    store.dispatch(DecreaseFontSizeAction());
  }

  void _resetFontSize(
    Store<AppState> store,
  ) {
    store.dispatch(ResetFontSizeAction());
  }

  ///
  /// Audio
  ///
  void _onAudioPlayStatusChanged(QuranAudioEventsEnum event, Store<AppState> store,) {
    switch (event) {
      case QuranAudioEventsEnum.stopped:
        store.dispatch(SetAudioContinuousPlayMode(isEnabled: false));
        break;

      case QuranAudioEventsEnum.loadNext:
        store.dispatch(NextAyaAction());
        break;

      case QuranAudioEventsEnum.contPlayStatusChanged:
        bool currentContinuousAudioPlayingStatus = store.state.reader.isAudioContinuousModeEnabled;
        store.dispatch(SetAudioContinuousPlayMode(isEnabled: !currentContinuousAudioPlayingStatus));
        break;

      default:
        break;
    }
  }

  /// display next aya
  void _moveToNextAyat(Store<AppState> store,) {
    store.dispatch(NextAyaAction());
  }

  /// display previous aya
  void _moveToPreviousAyat(Store<AppState> store,) {
    store.dispatch(PreviousAyaAction());
  }

}
