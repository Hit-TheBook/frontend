import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String baseUrl = 'http://13.209.78.125'; // 서버 URL
  static const String temporaryToken = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0M0BleGFtcGxlLmNvbV85Mmlvc2RmOTNpc2Rmamkzb2kyMzRtb2ZzZGlqMiIsImlhdCI6MTcyNTk0MjA4MywiZXhwIjoxNzI1OTQ1NjgzfQ.vrGWoliWNvwtsaI6nBvYI6_NfuxN6oMUZThEw-75cFh7Qkq_IibQVjAHKGl8-NoPEZn_ZSC5nknaFovMs4aNAw'; // 서버에서 발급받은 임시 토큰

  // GET 요청
  static Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/dday/list');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken', // 헤더에 토큰 추가
        'Content-Type': 'application/json',
      },
    );
    debugPrint('Authorization header: Bearer $temporaryToken');
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
  static Future<Map<String, dynamic>> addDday(Map<String, dynamic> dday) async {
    final response = await postRequest('dday', dday);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add Dday');
    }
  }

  // Dday 수정
  static Future<Map<String, dynamic>> updateDday(String id, Map<String, dynamic> dday) async {
    final response = await putRequest('dday/$id', dday);

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
