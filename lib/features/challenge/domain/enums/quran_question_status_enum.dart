enum QuranQuestionStatusEnum { open, close }

extension QuranQuestionStatusEnumToString on QuranQuestionStatusEnum {
  String rawString() {
    switch (this) {
      case QuranQuestionStatusEnum.open:
        return "open";
      case QuranQuestionStatusEnum.close:
        return "close";
    }
  }
}
