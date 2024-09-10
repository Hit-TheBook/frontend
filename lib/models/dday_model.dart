import 'dart:convert';

class Dday {
  final String? ddayName;
  final DateTime? startDate;
  final DateTime? endDate;

  Dday({this.ddayName, this.startDate, this.endDate});

  // JSON -> Dday 객체 변환
  factory Dday.fromJson(Map<String, dynamic> json) {
    return Dday(
      ddayName: json['ddayName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  // Dday 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'ddayName': ddayName,
      'startDate': startDate?.toUtc().toIso8601String(),
      'endDate': endDate?.toUtc().toIso8601String(),
    };
  }
}
