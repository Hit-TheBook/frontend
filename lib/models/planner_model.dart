import 'dart:convert';

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

class ScheduleRequestModel {
  final String scheduleType;
  final DateTime scheduleDate;

  ScheduleRequestModel({
    required this.scheduleType,
    required this.scheduleDate,
  });

  // 서버로 보내기 위한 JSON 형태로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'scheduleType': scheduleType,
      'scheduleDate': formatDateTimeForJava(scheduleDate), // DateTime을 ISO 8601 형식으로 변환
    };
  }

  // 서버에서 받아온 데이터를 모델로 변환하는 메서드 (필요시)
  factory ScheduleRequestModel.fromJson(Map<String, dynamic> json) {
    return ScheduleRequestModel(
      scheduleType: json['scheduleType'],
      scheduleDate: DateTime.parse(json['scheduleDate']),
    );
  }
}

class TimeTableRequestModel {
  final DateTime scheduleDate;


  TimeTableRequestModel({

    required this.scheduleDate,
  });

  // 서버로 보내기 위한 JSON 형태로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'scheduleDate': formatDateTimeForJava(scheduleDate),
      // DateTime을 ISO 8601 형식으로 변환
    };
  }



}
class TimeTableResponseModel {

  final String scheduleTitle;
  final String content;
  final DateTime startAt;
  final DateTime endAt;


  TimeTableResponseModel({
    // 선택적 파라미터로 수정
    required this.startAt,
    required this.scheduleTitle,
    required this.content,
    required this.endAt,

  });

  // JSON에서 객체로 변환하는 메서드
  factory TimeTableResponseModel.fromJson(Map<String, dynamic> json) {
    return TimeTableResponseModel(
      startAt: DateTime.parse(json['startAt']),
       scheduleTitle: json['scheduleTitle'],
        content: json['content'],
      endAt: DateTime.parse(json['endAt']),

    );
  }
}
class FeedbackRequest {
  final String scheduleType; // 스케줄타입
  final int plannerScheduleId; // 일정 ID
  final String result;

  FeedbackRequest({required this.scheduleType, required this.plannerScheduleId,required this.result});

  Map<String, dynamic> toJson() => {
    'scheduleType': scheduleType,
    'plannerScheduleId': plannerScheduleId,
    'result' : result,
  };
}

class FeedbackResponse {
  final String message; // 요청 결과

  FeedbackResponse({required this.message});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      message: json['message'],
    );
  }
}
class ScheduleModel {
  final int plannerScheduleId; // 스케줄 ID
  final String scheduleTitle;
  final String content;
  final DateTime startAt;
  final DateTime endAt;
  final String feedbackType;

  ScheduleModel({
    required this.plannerScheduleId, // 필수로 추가
    required this.scheduleTitle,
    required this.content,
    required this.startAt,
    required this.endAt,
    required this.feedbackType,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      plannerScheduleId: json['plannerScheduleId'], // JSON에서 ID를 가져오기
      scheduleTitle: json['scheduleTitle'],
      content: json['content'],
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
      feedbackType: json['feedbackType'],
    );
  }
}



