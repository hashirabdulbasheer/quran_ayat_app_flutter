import 'quran_tag_aya.dart';

class QuranTag {
  final String? id;
  final String name;
  final List<QuranTagAya> ayas;
  final int createdOn;
  final String status;

  QuranTag({
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
}
