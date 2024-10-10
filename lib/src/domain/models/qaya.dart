import 'domain_models.dart';

class QAya extends Equatable {
  final String index;
  final String text;

  const QAya({
    required this.index,
    required this.text,
  });

  @override
  List<Object?> get props => [
        index,
        text,
      ];
}
