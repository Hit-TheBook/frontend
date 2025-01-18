import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 안전한 스토리지
import '../main.dart';
import '../models/refresh_token_request_model.dart';
import '../pages/login_page.dart';


class RefreshTokenApiHelper {
  static const String baseUrl = 'http://13.209.78.125';
  final FlutterSecureStorage storage = FlutterSecureStorage(); // FlutterSecureStorage 인스턴스 생성



  Future<RefreshTokenResponseModel> refreshToken() async {
    print('Fetching refresh token from secure storage...');
    // 저장된 리프레시 토큰 가져오기
    String? refreshToken = await storage.read(key: 'refreshToken');

    if (refreshToken == null) {
      print('No refresh token found in storage.');
      _navigateToLoginPage();
      throw Exception('No refresh token found');
    }

    // 리프레시 토큰 요청을 위한 모델 생성
    RefreshTokenRequestModel requestModel = RefreshTokenRequestModel(refreshToken: refreshToken);
    print('Request model created: ${requestModel.toJson()}');

    print('Sending refresh token: ${requestModel.refreshToken}');

    // API 호출
    print('Sending POST request to $baseUrl/login/token/issue');
    // Access token을 저장된 곳에서 가져오기


    final response = await http.post(
      Uri.parse('$baseUrl/login/token/issue'), // 실제 리프레시 토큰 API URL로 대체
      headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',},

      body: jsonEncode(requestModel.toJson()), // 요청 모델을 JSON 형식으로 변환
    );

    // 응답 상태 코드 확인
    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      // 응답에서 새로운 액세스 토큰과 리프레시 토큰을 추출합니다.
      var data = jsonDecode(response.body);
      String newAccessToken = data['accessToken'];
      String newRefreshToken = data['refreshToken'];

      // 새로운 토큰을 안전한 스토리지에 저장합니다.
      await storage.write(key: 'accessToken', value: newAccessToken);
      await storage.write(key: 'refreshToken', value: newRefreshToken);

      print('새로운 Access Token: $newAccessToken');
      print('새로운 Refresh Token: $newRefreshToken');

      return RefreshTokenResponseModel.fromJson(jsonDecode(response.body));
    } else {
      print('Error: ${response.body}');
      _navigateToLoginPage(); // ✅ 토큰 갱신 실패 시 로그인 페이지로 이동
      throw Exception('Failed to refresh token');
    }
  }
  void _navigateToLoginPage() {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }


}