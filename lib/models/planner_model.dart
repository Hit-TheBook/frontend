import 'package:intl/intl.dart';

String formatDateTimeForJava(DateTime dateTime) {
  DateTime utcDateTime = dateTime.toUtc();
  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  return formatter.format(dateTime) ;
}


class ReviewModel {
  final DateTime reviewAt;
  final String? content;

  ReviewModel({
    required this.reviewAt,
    this.content,
  });

  // 서버로 보내기 위한 JSON 변환 메서드
  Map<String, dynamic> toJson() {
    final data = {
      'reviewAt': formatDateTimeForJava(reviewAt),
    };
    if (content != null) {
      data['content'] = content!; // content가 있을 때만 JSON에 포함
    }
    return data;
  }

  // 서버에서 받아온 데이터를 모델로 변환하는 메서드
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewAt: DateTime.parse(json['reviewAt']),
      content: json['content'],
    );
  }
}

class PlannerModel {
  final String scheduleTitle;
  final String content;
  final DateTime scheduleAt;
  final DateTime startAt;
  final DateTime endAt;

  PlannerModel({
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
  factory PlannerModel.fromJson(Map<String, dynamic> json) {
    return PlannerModel(
      scheduleTitle: json['scheduleTitle'],
      content: json['content'],
      scheduleAt: DateTime.parse(json['scheduleAt']),
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
    );
  }
}
