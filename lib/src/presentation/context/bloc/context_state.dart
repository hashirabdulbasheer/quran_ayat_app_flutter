part of 'context_bloc.dart';

@immutable
abstract class ContextState extends Equatable {}

final class ContextInitialState extends ContextState {
  @override
  List<Object?> get props => [];
}

final class ContextLoadedState extends ContextState {
  final SurahIndex index;
  final SuraTitle title;
  final QPageData data;
  final double textScale;

  ContextLoadedState({
    required this.index,
    required this.title,
    required this.data,
    required this.textScale,
  });

  @override
  List<Object?> get props => [
        index,
        title,
        data,
        textScale,
      ];
}
