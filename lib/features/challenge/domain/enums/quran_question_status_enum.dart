enum QuranQuestionStatusEnum { open, close, undefined }

extension QuranQuestionStatusEnumToString on QuranQuestionStatusEnum {
  String rawString() {
    switch (this) {
      case QuranQuestionStatusEnum.open:
        return "open";
      case QuranQuestionStatusEnum.close:
        return "close";

      default:
        return "undefined";
    }
  }
}
