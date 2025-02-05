import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project1/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginApiHelper {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<LoginResponseModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailId': email, 'password': password}),
    );

    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      String accessToken = jsonResponse['accessToken'];
      String refreshToken = jsonResponse['refreshToken'];

      // SecureStorage에 토큰 저장
      await _secureStorage.write(key: 'accessToken', value: accessToken);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);

      return LoginResponseModel.fromJson(jsonResponse);
    } else {
      return LoginResponseModel(accessToken: '', message: '로그인 실패');
    }
  }
  Future<Map<String, String?>> getTokens() async {
    String? accessToken = await _secureStorage.read(key: 'accessToken');
    String? refreshToken = await _secureStorage.read(key: 'refreshToken');

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }


}


