import 'package:ayat_app/src/core/core.dart';
import 'package:ayat_app/src/data/models/local/data_local_models.dart';
import 'package:ayat_app/src/domain/models/domain_models.dart';
import 'package:flutter/material.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl extends SettingsRepository {
  SettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  final NQTranslationToQTranslationMapper _nqTranslationToQTranslationMapper =
      NQTranslationToQTranslationMapper();

  final QTranslationToNQTranslationMapper _qTranslationToNQTranslationMapper =
      QTranslationToNQTranslationMapper();

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

  @override
  QTranslation getDefaultTranslation() {
    NQTranslation nqTranslation = dataSource.getDefaultTranslation();
    return _nqTranslationToQTranslationMapper.mapFrom(nqTranslation);
  }

  @override
  Future<void> setDefaultTranslation(QTranslation translation) {
    return dataSource.setDefaultTranslation(
        _qTranslationToNQTranslationMapper.mapFrom(translation));
  }

  @override
  bool? getIsWordByWordTranslationEnabled() {
    return dataSource.getIsWordByWordTranslationEnabled();
  }

  @override
  Future<void> setIsWordByWordTranslationEnabled(bool isEnabled) {
    return dataSource.setIsWordByWordTranslationEnabled(isEnabled);
  }
}
