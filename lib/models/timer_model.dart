class TimerSubjectRequest {
  final String subjectName;
  final int? subjectId; // 수정 시 필요한 subjectId
  final int? totalScore; // 누적 점수
  final Map<String, dynamic>? totalStudyTime; // 서버에서 받은 시간 데이터
  final String? studyTimeLength; // 변환된 HH:MM:SS 형식의 시간

  TimerSubjectRequest({
    required this.subjectName,
    this.subjectId,
    this.totalScore,
    this.totalStudyTime,
    this.studyTimeLength,
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      if (subjectId != null) 'subjectId': subjectId,
      if (totalScore != null) 'totalScore': totalScore,
      if (totalStudyTime != null) 'totalStudyTime': totalStudyTime,
    };
  }

  // JSON을 객체로 변환하는 팩토리 생성자
  factory TimerSubjectRequest.fromJson(Map<String, dynamic> json) {
    final totalStudyTime = json['totalStudyTime'] as Map<String, dynamic>?;

    // 시간을 HH:MM:SS로 변환
    final studyTimeLength = totalStudyTime != null
        ? _convertTimeFormat(totalStudyTime['seconds'])
        : null;

    return TimerSubjectRequest(
      subjectName: json['subjectName'],
      subjectId: json['subjectId'],
      totalScore: json['totalScore'],
      totalStudyTime: totalStudyTime,
      studyTimeLength: studyTimeLength,
    );
  }

  // totalStudyTime의 seconds를 HH:MM:SS 형식으로 변환하는 메서드
  static String _convertTimeFormat(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
class TimerEndRequest {
  final String studyTimeLength; // "00:00:00" 형식의 스트링
  final String targetTime;      // "00:00:00" 형식의 스트링
  final int score;              // 점수

  TimerEndRequest({
    required this.studyTimeLength,
    required this.targetTime,
    required this.score,
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'studyTimeLength': studyTimeLength,
      'targetTime': targetTime,
      'score': score,
    };
  }

  // JSON에서 모델로 변환
  factory TimerEndRequest.fromJson(Map<String, dynamic> json) {
    return TimerEndRequest(
      studyTimeLength: json['studyTimeLength'],
      targetTime: json['targetTime'],
      score: json['score'],
    );
  }

}
class TimerData {
  final String? studyTimeLength; // studyTimeLength는 이제 String으로 변경
  final int score;
  final int presentLevel;

  TimerData({
    this.studyTimeLength,
    required this.score,
    required this.presentLevel,
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'studyTimeLength': studyTimeLength,
      'score': score,
      'presentLevel': presentLevel,
    };
  }

  // JSON에서 객체로 변환하는 팩토리 생성자
  factory TimerData.fromJson(Map<String, dynamic> json) {
    return TimerData(
      studyTimeLength: json['studyTimeLength'] as String?, // studyTimeLength는 String 타입으로 처리
      score: json['score'] ?? 0,
      presentLevel: json['presentLevel'] ?? 0,
    );
  }
}

