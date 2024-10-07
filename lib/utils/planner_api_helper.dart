import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project1/models/planner_model.dart';  // 모델 파일을 임포트


class PlannerApiHelper {
  static const String baseUrl = 'http://13.209.78.125';
  static const String temporaryToken = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0M0BleGFtcGxlLmNvbV85Mmlvc2RmOTNpc2Rmamkzb2kyMzRtb2ZzZGlqMiIsImlhdCI6MTcyNTk0NjQxOSwiZXhwIjoxNzU3NDgyNDE5fQ.t-LwL_f9huhSTzDMGLWLF_PAgqVq4NAk49kx1weMuFY1-eVY6OEBC1qm0rkmNyJAdIMylYtAuVq8Y8LS9IdUhQ'; // 서버에서 발급받은 임시 토큰


  static Future<http.Response> addPlanner(String scheduleType, PlannerModel model) async {
    final String endpoint = 'planner/schedule/$scheduleType';
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(model.toJson()), // 모델을 JSON으로 변환하여 전송
    );

    // 디버깅 출력
    debugPrint('Request data: ${model.toJson()}');
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  static Future<http.Response> addReview(String reviewAt, ReviewModel model) async {
    final String endpoint = 'planner/daily/review/$reviewAt';
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(model.toJson()), // 모델을 JSON으로 변환하여 전송
    );

    // 디버깅 출력
    debugPrint('Request data: ${model.toJson()}');
    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  static Future<http.Response> modifyReview(String reviewAt, String content) async {
    final url = Uri.parse('$baseUrl/planner/daily/review/$reviewAt');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken', // 헤더에 토큰 추가
        'Content-Type': 'application/json',
      },
      body: json.encode({'content': content}),
    );

    debugPrint('PUT $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  static Future<http.Response> findReview(String reviewAt) async {
    final url = Uri.parse('$baseUrl/planner/daily/review/$reviewAt');
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

  static Future<http.Response> findPlanner(ScheduleRequestModel requestModel) async {
    final formattedDate = formatDateTimeForJava(requestModel.scheduleDate); // ISO 8601 형식으로 변환
    final url = Uri.parse('$baseUrl/planner/schdule/${requestModel.scheduleType}/$formattedDate');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $temporaryToken',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('GET $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }



}
