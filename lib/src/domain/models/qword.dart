import 'package:ayat_app/src/domain/models/domain_models.dart';

class QWord extends Equatable {
  final int word;
  final String tr;
  final int aya;
  final int sura;
  final String ar;

  const QWord({
    required this.word,
    required this.tr,
    required this.aya,
    required this.sura,
    required this.ar,
  });

  @override
  List<Object?> get props => [
        word,
        tr,
        aya,
        sura,
        ar,
      ];
}
