import 'dart:convert';

class RequestDday {
  // ddayId 필드 추가
  final String ddayName;
  final DateTime startDate;
  final DateTime endDate;

  RequestDday({
     // 선택적 파라미터로 수정
    required this.ddayName,
    required this.startDate,
    required this.endDate,
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'ddayName': ddayName,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
    };
  }
}

class ResponsePrimaryDday {
  // ddayId 필드 추가
  final String ddayName;
  final String message;
  final int remainingDays;
  ResponsePrimaryDday({
    // 선택적 파라미터로 수정
    required this.ddayName,
    required this.message,
    required this.remainingDays,
  });

  // JSON에서 객체로 변환하는 메서드
  factory ResponsePrimaryDday.fromJson(Map<String, dynamic> json) {
    return ResponsePrimaryDday(
      // ddayId 추가
      ddayName: json['ddayName'],
      message: json['message'],
      remainingDays: json['remainingDays']
    );
  }
}



class DdayInfo {
  final int ddayId;
  final String ddayName;
  final int remainingDays;
  final DateTime startDate;
  final DateTime endDate;

  DdayInfo({
    required this.ddayId,
    required this.remainingDays,
    required this.ddayName,
    required this.startDate,
    required this.endDate,
  });

  factory DdayInfo.fromJson(Map<String, dynamic> json) {
    return DdayInfo(
      ddayId: json['ddayId'] as int,
      ddayName: json['ddayName'] as String,
      remainingDays: json['remainingDays'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }
}

class ResponseDdayList {
  final String message;
  final DdayInfo primaryDay;
  final List<DdayInfo> upComingDdays;
  final List<DdayInfo> oldDdays;

  ResponseDdayList({
    required this.message,
    required this.primaryDay,
    required this.upComingDdays,
    required this.oldDdays,
  });

  factory ResponseDdayList.fromJson(Map<String, dynamic> json) {
    return ResponseDdayList(
      message: json['message'] as String,
      primaryDay: DdayInfo.fromJson(json['primaryDay'] as Map<String, dynamic>),
      upComingDdays: (json['upComingDdays'] as List<dynamic>)
          .map((item) => DdayInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
      oldDdays: (json['oldDdays'] as List<dynamic>)
          .map((item) => DdayInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
