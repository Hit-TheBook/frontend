import 'dart:convert';

// Dday 모델 클래스
class Dday {
  final String ddayName;
  final DateTime startDate;
  final DateTime endDate;

  // 생성자
  Dday({
    required this.ddayName,
    required this.startDate,
    required this.endDate,
  });

  // JSON으로부터 Dday 객체 생성
  factory Dday.fromJson(Map<String, dynamic> json) {
    return Dday(
      ddayName: json['ddayName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  // Dday 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'ddayName': ddayName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
