import 'package:ayat_app/src/domain/models/qaya.dart';
import 'package:equatable/equatable.dart';

class QSura extends Equatable {
  final List<QAya> aya;
  final String index;
  final String? name;

  const QSura({
    required this.aya,
    required this.index,
    required this.name,
  });

  @override
  List<Object?> get props => [
        aya,
        index,
        name,
      ];
}