enum QuranAnswerStatusEnum { submitted, approved, rejected, undefined }

extension QuranAnswerStatusEnumToString on QuranAnswerStatusEnum {
  String rawString() {
    switch (this) {
      case QuranAnswerStatusEnum.submitted:
        return "submitted";
      case QuranAnswerStatusEnum.approved:
        return "approved";
      case QuranAnswerStatusEnum.rejected:
        return "rejected";

      default:
        return "undefined";
    }
  }
}
