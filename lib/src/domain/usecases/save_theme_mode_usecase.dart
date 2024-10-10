import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';
import 'package:flutter/material.dart';

@injectable
class SaveThemeModeUseCase extends UseCaseAsync<void, ThemeMode> {
  final SettingsRepository _repository;

  SaveThemeModeUseCase(this._repository);

  @override
  Future call(ThemeMode params) async {
    return _repository.setThemeMode(params);
  }
}
