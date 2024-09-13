import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApiHelper {
  final String baseUrl = 'http://13.209.78.125';

  Future<bool> sendAuthCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/join/mail/authorization'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailId': email}),
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyAuthCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/join/mail/authorization/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailId': email, 'authCode': code}),
    );
    return response.statusCode == 200;
  }

  Future<bool> registerUser(String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
      }),
    );
    return response.statusCode == 200;
  }
}
