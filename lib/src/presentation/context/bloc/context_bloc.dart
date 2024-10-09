import 'package:ayat_app/src/domain/models/qdata.dart';
import 'package:ayat_app/src/domain/models/sura_title.dart';
import 'package:ayat_app/src/domain/models/surah_index.dart';
import 'package:ayat_app/src/domain/usecases/fetch_font_scale_usecase.dart';
import 'package:ayat_app/src/domain/usecases/fetch_sura_data_usecase.dart';
import 'package:ayat_app/src/domain/usecases/fetch_sura_titles_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'context_event.dart';
part 'context_state.dart';

@injectable
class ContextBloc extends Bloc<ContextEvent, ContextState> {
  final FetchFontScaleUseCase fetchFontScaleUseCase;
  final FetchSuraUseCase fetchSuraUseCase;
  final FetchSuraTitlesUseCase fetchSuraTitlesUseCase;

  ContextBloc({
    required this.fetchSuraUseCase,
    required this.fetchSuraTitlesUseCase,
    required this.fetchFontScaleUseCase,
  }) : super(ContextInitialState()) {
    on<ContextInitializeEvent>(_onInitialize);
  }

  void _onInitialize(
    ContextInitializeEvent event,
    Emitter<ContextState> emit,
  ) async {
    // int sura = event.index.sura;
    // final textScale = fetchFontScaleUseCase.call();
    // TODO: Handle translations with multiple translations
    // final fetchSura = await fetchSuraUseCase.call(FetchSuraUseCaseParams(
    //   suraIndex: sura,
    //   translation: QTranslation.wahiduddinKhan,
    // ));
    // await fetchSura.fold((left) {}, (data) async {
    //   final fetchTitle = await fetchSuraTitlesUseCase.call(NoParams());
    //   fetchTitle.fold((left) {}, (title) {
    //     emit(ContextLoadedState(
    //       index: event.index,
    //       title: title[event.index.sura],
    //       data: data,
    //       textScale: textScale,
    //     ));
    //   });
    // });
  }
}
