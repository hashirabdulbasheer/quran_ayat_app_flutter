import 'package:ayat_app/src/core/usecases/usecases.dart';
import 'package:ayat_app/src/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveThemeModeUseCase extends UseCaseAsync<void, ThemeMode> {
  final SettingsRepository _repository;

  SaveThemeModeUseCase(this._repository);

  @override
  Future call(ThemeMode params) async {
    return _repository.setThemeMode(params);
  }
}
