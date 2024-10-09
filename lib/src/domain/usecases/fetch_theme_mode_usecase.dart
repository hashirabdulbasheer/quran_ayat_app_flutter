import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchThemeModeUseCase extends UseCaseSync<ThemeMode> {
  final SettingsRepository _repository;

  FetchThemeModeUseCase(this._repository);

  @override
  ThemeMode call() {
    return _repository.getThemeMode();
  }
}
