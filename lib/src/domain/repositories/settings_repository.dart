import 'package:flutter/material.dart';

abstract class SettingsRepository {
  double getFontScale();

  Future<void> setFontScale(double fontSize);

  ThemeMode getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);
}
