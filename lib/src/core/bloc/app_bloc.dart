import 'package:ayat_app/src/domain/usecases/fetch_theme_mode_usecase.dart';
import 'package:ayat_app/src/domain/usecases/save_theme_mode_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'app_event.dart';
part 'app_state.dart';

@LazySingleton()
class AppBloc extends Bloc<AppEvent, AppState> {
  final FetchThemeModeUseCase fetchThemeModeUseCase;
  final SaveThemeModeUseCase saveThemeModeUseCase;

  final currentThemeMode$ = BehaviorSubject<ThemeMode>.seeded(ThemeMode.light);

  AppBloc(
      {required this.fetchThemeModeUseCase, required this.saveThemeModeUseCase})
      : super(AppInitial()) {
    on<AppInitializeEvent>(_onAppInitialize);
    on<ToggleThemeModeEvent>(_onToggleThemeMode);
  }

  @override
  Future<void> close() async {
    currentThemeMode$.close();
    return super.close();
  }

  void _onAppInitialize(AppInitializeEvent event, Emitter<AppState> emit) {
    ThemeMode mode = fetchThemeModeUseCase.call();
    currentThemeMode$.add(mode);
    emit(AppLoadedState());
  }

  void _onToggleThemeMode(
      ToggleThemeModeEvent event, Emitter<AppState> emit) async {
    ThemeMode mode = currentThemeMode$.value;
    ThemeMode newMode =
        (mode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    await saveThemeModeUseCase.call(newMode);
    currentThemeMode$.add(newMode);
  }
}
