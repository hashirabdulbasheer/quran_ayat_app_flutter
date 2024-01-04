/// Quran App Mode
enum QuranAppMode { basic, advanced }

extension QuranAppModeToString on QuranAppMode {
  String rawString() {
    switch (this) {
      case QuranAppMode.basic:
        return "Basic";
      case QuranAppMode.advanced:
        return "Advanced";
    }
  }
}
