import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dday_model.dart'; // 모델 클래스를 import합니다.

class ApiHelper {
  static const String baseUrl = 'http://13.209.78.125'; // 서버 URL
  static const String temporaryToken = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0M0BleGFtcGxlLmNvbV85Mmlvc2RmOTNpc2Rmamkzb2kyMzRtb2ZzZGlqMiIsImlhdCI6MTcyNTk0NjQxOSwiZXhwIjoxNzU3NDgyNDE5fQ.t-LwL_f9huhSTzDMGLWLF_PAgqVq4NAk49kx1weMuFY1-eVY6OEBC1qm0rkmNyJAdIMylYtAuVq8Y8LS9IdUhQ'; // 서버에서 발급받은 임시 토큰

  // GET 요청
  static Future<http.Response> getRequest(String endpoint) async {
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
  static Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken', // 헤더에 토큰 추가
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  // PUT 요청
  static Future<http.Response> putRequest(String endpoint, Map<String, dynamic> data) async {
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
  static Future<http.Response> deleteRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
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

  // Dday 추가
  static Future<Map<String, dynamic>> addDday(RequestDday dday) async {
    final response = await postRequest('dday', dday.toJson());

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add Dday');
    }
  }

  // Dday 수정
  static Future<Map<String, dynamic>> updateDday(String id, RequestDday dday) async {
    final response = await putRequest('dday/$id', dday.toJson());

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update Dday');
    }
  }

  // Dday 삭제
  static Future<void> deleteDday(String id) async {
    final response = await deleteRequest('dday/$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Dday');
    }
  }
}
