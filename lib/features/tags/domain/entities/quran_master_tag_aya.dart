class QuranMasterTagAya {
  final int suraIndex;
  final int ayaIndex;

  QuranMasterTagAya({
    required this.suraIndex,
    required this.ayaIndex,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "sura": suraIndex,
      "aya": ayaIndex,
    };
  }
}
