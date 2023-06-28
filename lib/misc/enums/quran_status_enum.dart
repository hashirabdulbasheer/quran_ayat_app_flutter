/// Quran Update Status
enum QuranStatusEnum  { created, updated, deleted }

extension QuranStatusEnumToString on QuranStatusEnum {
  String rawString() {
    switch (this) {
      case QuranStatusEnum.created:
        return "created";
      case QuranStatusEnum.updated:
        return "updated";
      case QuranStatusEnum.deleted:
        return "deleted";
    }
  }
}
