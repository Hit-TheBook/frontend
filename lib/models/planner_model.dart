import 'package:intl/intl.dart';

String formatDateTimeForJava(DateTime dateTime) {
  DateTime utcDateTime = dateTime.toUtc();
  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  return formatter.format(dateTime) ;
}

class ReviewModel {
final DateTime reviewAt;

}
class PlanerModel {
  final String scheduleTitle;
  final String content;
  final DateTime scheduleAt;
  final DateTime startAt;
  final DateTime endAt;

  PlanerModel({
    required this.scheduleTitle,
    required this.content,
    required this.scheduleAt,
    required this.startAt,
    required this.endAt,
  });

  // 서버로 보내기 위한 JSON 형태로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'scheduleTitle': scheduleTitle,
      'content': content,
      'scheduleAt': formatDateTimeForJava(scheduleAt),
      'startAt': formatDateTimeForJava(startAt),
      'endAt': formatDateTimeForJava(endAt),
    };
  }

  // 서버에서 받아온 데이터를 모델로 변환하는 메서드 (필요시)
  factory PlanerModel.fromJson(Map<String, dynamic> json) {
    return PlanerModel(
      scheduleTitle: json['scheduleTitle'],
      content: json['content'],
      scheduleAt: DateTime.parse(json['scheduleAt']),
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
    );
  }
}
