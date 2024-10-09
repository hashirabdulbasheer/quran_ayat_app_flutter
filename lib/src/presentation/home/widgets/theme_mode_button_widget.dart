import 'package:ayat_app/src/core/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();

    return StreamBuilder<ThemeMode>(
        stream: appBloc.currentThemeMode$,
        builder: (context, snapshot) {
          ThemeMode mode = snapshot.data ?? ThemeMode.light;
          bool isDarkMode = mode == ThemeMode.dark;
          return IconButton(
              onPressed: () => appBloc.add(ToggleThemeModeEvent()),
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).primaryColor,
              ));
        });
  }
}
