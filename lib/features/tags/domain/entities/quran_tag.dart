import 'package:equatable/equatable.dart';

import 'quran_tag_aya.dart';

class QuranTag extends Equatable {
  final String? id;
  final String name;
  final List<QuranTagAya> ayas;
  final int createdOn;
  final String status;

  const QuranTag({
    required this.id,
    required this.name,
    required this.ayas,
    required this.createdOn,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "ayas": ayas.map((e) => e.toMap()).toList(),
      "createdOn": createdOn,
      "status": status,
    };
  }

  bool containsTag(String tag) {
    return name == tag;
  }

  @override
  String toString() {
    return 'QuranTag{id: $id, name: $name, ayas: $ayas, createdOn: $createdOn, status: $status}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        ayas,
        createdOn,
        status,
      ];
}
