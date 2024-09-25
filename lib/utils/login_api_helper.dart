import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project1/models/login_model.dart';

class LoginApiHelper {
  final String baseUrl = 'http://13.209.78.125';

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
      return LoginResponseModel.fromJson(jsonResponse);
    } else {
      return LoginResponseModel(accessToken: '', message: '로그인 실패');
    }
  }

}
