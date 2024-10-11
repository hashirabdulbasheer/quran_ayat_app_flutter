part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {}

class HomeLoadedState extends HomeState {
  // TODO: can be changed to map to improve performance, if required
  final List<SuraTitle>? suraTitles;
  final SurahIndex? bookmarkIndex;

  HomeLoadedState({this.suraTitles, this.bookmarkIndex});

  HomeLoadedState copyWith({
    List<SuraTitle>? suraTitles,
    SurahIndex? bookmarkIndex,
  }) {
    return HomeLoadedState(
      suraTitles: suraTitles ?? this.suraTitles,
      bookmarkIndex: bookmarkIndex ?? this.bookmarkIndex,
    );
  }

  @override
  List<Object?> get props => [
        suraTitles,
        bookmarkIndex,
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
