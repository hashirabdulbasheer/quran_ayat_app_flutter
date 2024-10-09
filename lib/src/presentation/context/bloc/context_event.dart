part of 'context_bloc.dart';

@immutable
abstract class ContextEvent extends Equatable {}

class ContextInitializeEvent extends ContextEvent {
  final SurahIndex index;

  ContextInitializeEvent({required this.index});

  @override
  List<Object?> get props => [index];
}
