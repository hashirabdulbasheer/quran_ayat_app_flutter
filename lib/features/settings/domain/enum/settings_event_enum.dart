enum QuranSettingsEvent { transliterationChanged, translationChanged }

extension QuranSettingsEventToString on QuranSettingsEvent {
  String rawString() {
    switch (this) {
      case QuranSettingsEvent.transliterationChanged:
        return "transliterationChanged";
      case QuranSettingsEvent.translationChanged:
        return "translationChanged";
    }
  }
}
