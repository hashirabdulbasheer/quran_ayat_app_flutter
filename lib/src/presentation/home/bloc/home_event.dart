part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {}

class HomeInitializeEvent extends HomeEvent {
  final SurahIndex? index;
  final int numberOfAyaPerPage;

  HomeInitializeEvent({
    required this.numberOfAyaPerPage,
    this.index,
  });

  @override
  List<Object?> get props => [
        numberOfAyaPerPage,
        index,
      ];
}

class HomeFetchQuranDataEvent extends HomeEvent {
  final int pageNo;
  final SurahIndex? selectedIndex;

  HomeFetchQuranDataEvent({
    required this.pageNo,
    this.selectedIndex,
  });

  @override
  List<Object?> get props => [
        pageNo,
        selectedIndex,
      ];
}

class HomeNextPageEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomePreviousPageEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeSelectSuraAyaEvent extends HomeEvent {
  final SurahIndex index;

  HomeSelectSuraAyaEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class TextSizeControlEvent extends HomeEvent {
  final TextSizeControl type;

  TextSizeControlEvent({
    required this.type,
  });

  @override
  List<Object?> get props => [type];
}

class GoToBookmarkEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class AddBookmarkEvent extends HomeEvent {
  final SurahIndex index;

  AddBookmarkEvent({required this.index});

  @override
  List<Object?> get props => [index];
}
