import 'quran_master_tag_aya.dart';

class QuranMasterTag {
  final int id;
  final String name;
  final List<QuranMasterTagAya> ayas;
  final int createdOn;
  final String status;

  QuranMasterTag({
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
      "ayas": ayas,
      "createdOn": createdOn,
      "status": status,
    };
  }
}
