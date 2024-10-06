import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApiHelper {
  final String baseUrl = 'http://13.209.78.125';

  Future<http.Response> sendAuthCode(String email) async {
    final url = Uri.parse('$baseUrl/mail/join/authorization');
    final response = await http.post(
      Uri.parse('$baseUrl/mail/join/authorization'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailId': email}),
    );
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response;

  }

  Future<bool> verifyAuthCode(String email, String code) async {
    final url = Uri.parse('$baseUrl/mail/authorization/verify');
    final response = await http.post(
      Uri.parse('$baseUrl/mail/authorization/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailId': email, 'authCode': code}),
    );
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.statusCode == 200;

  }

  Future<bool> registerUser(String email, String password, String nickname) async {
    final url = Uri.parse('$baseUrl/join');
    final response = await http.post(
      Uri.parse('$baseUrl/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'emailId': email,
        'password': password,
        'nickname': nickname,
      }),
    );
    debugPrint('$email,$password,$nickname');
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.statusCode == 200;

  }

  Future<bool> sendResetAuthCode(String email) async {
    final url = Uri.parse('$baseUrl/mail/forget/authorization');
    final response = await http.post(
      Uri.parse('$baseUrl/mail/forget/authorization'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailId': email}),
    );
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.statusCode == 200;

  }


  Future<http.Response> checkPreviousPassword(String email, String password) async {
    final url = Uri.parse('$baseUrl/forget/password/current');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'emailId': email,
        'password': password,
      }),
    );

    debugPrint('$email,$password');
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response; // 응답 객체를 반환
  }



  Future<bool> resetPassword(String email, String password) async {
    final url = Uri.parse('$baseUrl/forget/password/reset');
    final response = await http.post(
      Uri.parse('$baseUrl/forget/password/reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'emailId': email,
        'password': password,

      }),
    );
    debugPrint('$email,$password');
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.statusCode == 200;

  }
}
