class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({required this.email, required this.password});

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'emailId': email,
      'password': password,
    };
  }

}
class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String message;

  LoginResponseModel({required this.accessToken,this.refreshToken = '', required this.message});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] ?? '', // accessToken이 없으면 빈 문자열
      message: json['message'] ?? '',
      refreshToken: json['refresh_token']?? '',
    );
  }
}

