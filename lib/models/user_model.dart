class UserResponse {
  final String nickname;


  UserResponse({
    required this.nickname,

  });

  // JSON으로부터 UserResponse 객체를 생성하는 팩토리 메서드
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      nickname: json['nickname'] as String,

    );
  }

  // UserResponse 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,

    };
  }

}
class Level {
  final int point;
  final int level;
  final String levelName;
  final int minPoint;
  final int maxPoint;

  Level({
    required this.point,
    required this.level,
    required this.levelName,
    required this.minPoint,
    required this.maxPoint,
  });

  // JSON을 Level 객체로 변환
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      point: json['point'],
      level: json['level'],
      levelName: json['levelName'],
      minPoint: json['minPoint'],
      maxPoint: json['maxPoint'],
    );
  }
}

class Emblem {
  final String emblemId;
  final String emblemName;
  final String emblemContent;
  final String emblemCreateAt;

  Emblem({
    required this.emblemId,
    required this.emblemName,
    required this.emblemContent,
    required this.emblemCreateAt,
  });

  factory Emblem.fromJson(Map<String, dynamic> json) {
    // emblemCreateAt 값을 DateTime 객체로 변환 후, 날짜 부분만 포맷
    String dateStr = json['emblemCreateAt'];
    DateTime date = DateTime.parse(dateStr); // 문자열을 DateTime으로 변환
    String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"; // yyyy-MM-dd 형식으로 포맷

    return Emblem(
      emblemId: json['emblemId'].toString(),
      emblemName: json['emblemName'],
      emblemContent: json['emblemContent'],
      emblemCreateAt: formattedDate, // 변환된 날짜만 사용
    );
  }
}
