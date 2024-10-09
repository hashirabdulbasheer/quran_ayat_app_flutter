part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {}

class HomeLoadedState extends HomeState {
  // TODO: can be changed to map to improve performance, if required
  final List<SuraTitle>? suraTitles;

  HomeLoadedState({
    this.suraTitles,
  });

  HomeLoadedState copyWith({
    List<SuraTitle>? suraTitles,
    int? numberOfAyaPerPage,
  }) {
    return HomeLoadedState(
      suraTitles: suraTitles ?? this.suraTitles,
    );
  }

  @override
  List<Object?> get props => [
        suraTitles,
      ];
}

class HomeErrorState extends HomeState {
  final String? message;

  HomeErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
