part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class AppInitializeEvent extends AppEvent{}

class ToggleThemeModeEvent extends AppEvent{}
