import 'package:ayat_app/src/data/local/settings_local_data_source.dart';
import 'package:ayat_app/src/data/models/local/enums/local_theme_mode_enum.dart';
import 'package:ayat_app/src/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl extends SettingsRepository {
  SettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  double getFontScale() {
    return dataSource.getFontScale();
  }

  @override
  Future<void> setFontScale(double fontSize) {
    return dataSource.setFontScale(fontSize);
  }

  @override
  ThemeMode getThemeMode() {
    LocalThemeMode localThemeMode = dataSource.getThemeMode();
    return localThemeMode == LocalThemeMode.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    LocalThemeMode localThemeMode =
        mode == ThemeMode.dark ? LocalThemeMode.dark : LocalThemeMode.light;
    return dataSource.setThemeMode(localThemeMode);
  }
}
