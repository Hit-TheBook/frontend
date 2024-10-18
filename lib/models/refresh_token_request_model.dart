class RefreshTokenRequestModel {
  final String refreshToken;

  RefreshTokenRequestModel({required this.refreshToken});

  Map<String, dynamic> toJson() => {
    'refresh_token': refreshToken,
  };
}

class RefreshTokenResponseModel {
  final String accessToken;
  final String refreshToken;
  final String message;

  RefreshTokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      accessToken: json['accessToken'] ?? '', // 기본값으로 빈 문자열을 설정
      refreshToken: json['refreshToken'] ?? '',
      message: json['message'],
    );
  }
}
