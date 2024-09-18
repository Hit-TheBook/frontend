import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dday_model.dart'; // 모델 클래스를 import합니다.
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiHelper {
  static const String baseUrl = 'http://13.209.78.125'; // 서버 URL
  static const String temporaryToken = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0M0BleGFtcGxlLmNvbV85Mmlvc2RmOTNpc2Rmamkzb2kyMzRtb2ZzZGlqMiIsImlhdCI6MTcyNTk0NjQxOSwiZXhwIjoxNzU3NDgyNDE5fQ.t-LwL_f9huhSTzDMGLWLF_PAgqVq4NAk49kx1weMuFY1-eVY6OEBC1qm0rkmNyJAdIMylYtAuVq8Y8LS9IdUhQ'; // 서버에서 발급받은 임시 토큰

  // GET 요청
  static Future<http.Response> findDdayList(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken', // 헤더에 토큰 추가
        'Content-Type': 'application/json',
      },
    );

    debugPrint('GET $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  // POST 요청
  static Future<http.Response> addDday(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken', // 헤더에 토큰 추가
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data), // RequestDday 객체를 JSON 문자열로 변환
    );
    debugPrint('Request data: $data');
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  // PUT 요청
  static Future<http.Response> modifyDday(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken', // 헤더에 토큰 추가
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    debugPrint('PUT $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  // DELETE 요청
  static Future<http.Response> deleteDday(String endpoint) async {
    final url = Uri.parse('$baseUrl/dday/$endpoint');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken', // 헤더에 토큰 추가
        'Content-Type': 'application/json',
      },
    );

    debugPrint('DELETE $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }
}