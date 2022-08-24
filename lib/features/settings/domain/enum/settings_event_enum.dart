enum QuranSettingsEvent {
  transliterationChanged,
  translationChanged,
  audioControlStatusChanged
}

extension QuranSettingsEventToString on QuranSettingsEvent {
  String rawString() {
    switch (this) {
      case QuranSettingsEvent.transliterationChanged:
        return "transliterationChanged";
      case QuranSettingsEvent.translationChanged:
        return "translationChanged";
      case QuranSettingsEvent.audioControlStatusChanged:
        return "audioControlStatusChanged";
    }
  }
}
