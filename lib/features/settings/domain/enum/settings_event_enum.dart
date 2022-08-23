enum QuranSettingsEvent { transliterationChanged }

extension QuranSettingsEventToString on QuranSettingsEvent {
  String rawString() {
    switch (this) {
      case QuranSettingsEvent.transliterationChanged:
        return "transliterationChanged";
    }
  }
}
