class AyahDto {
  const AyahDto({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.page,
    required this.juz,
    required this.hizbQuarter,
    required this.ruku,
    required this.sajda,
    this.audio,
  });

  factory AyahDto.fromJson(Map<String, dynamic> json) {
    return AyahDto(
      number: json['number'] as int,
      text: json['text'] as String,
      numberInSurah: json['numberInSurah'] as int,
      page: json['page'] as int,
      juz: json['juz'] as int,
      hizbQuarter: json['hizbQuarter'] as int,
      ruku: json['ruku'] as int,
      sajda: json['sajda'] == true,
      audio: json['audio'] as String?,
    );
  }

  final int number;
  final String text;
  final int numberInSurah;
  final int page;
  final int juz;
  final int hizbQuarter;
  final int ruku;
  final bool sajda;
  final String? audio;
}
