class QuranTagAya {
  final int suraIndex;
  final int ayaIndex;

  QuranTagAya({
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
