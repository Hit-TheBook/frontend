class UserResponse {
  final String nickname;
  final int point;

  UserResponse({
    required this.nickname,
    required this.point,
  });

  // JSON으로부터 UserResponse 객체를 생성하는 팩토리 메서드
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      nickname: json['nickname'] as String,
      point: json['point'] as int,
    );
  }

  // UserResponse 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'point': point,
    };
  }
}
