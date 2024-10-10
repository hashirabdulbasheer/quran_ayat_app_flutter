import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';
import 'package:flutter/material.dart';

@injectable
class FetchThemeModeUseCase extends UseCaseSync<ThemeMode> {
  final SettingsRepository _repository;

  FetchThemeModeUseCase(this._repository);

  @override
  ThemeMode call() {
    return _repository.getThemeMode();
  }
}
