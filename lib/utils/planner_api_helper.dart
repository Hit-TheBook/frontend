import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project1/models/planner_model.dart';  // 모델 파일을 임포트
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'refresh_token_api_helper.dart';


class PlannerApiHelper {
  static const String baseUrl = 'http://13.209.78.125';
  // static const String temporaryToken = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0M0BleGFtcGxlLmNvbV85Mmlvc2RmOTNpc2Rmamkzb2kyMzRtb2ZzZGlqMiIsImlhdCI6MTcyNTk0NjQxOSwiZXhwIjoxNzU3NDgyNDE5fQ.t-LwL_f9huhSTzDMGLWLF_PAgqVq4NAk49kx1weMuFY1-eVY6OEBC1qm0rkmNyJAdIMylYtAuVq8Y8LS9IdUhQ'; // 서버에서 발급받은 임시 토큰
  final FlutterSecureStorage storage = FlutterSecureStorage(); // FlutterSecureStorage 인스턴스 생성
  final RefreshTokenApiHelper refreshTokenHelper = RefreshTokenApiHelper(); // 토큰 갱신 헬퍼 인스턴스


  Future<http.Response> addPlanner(String scheduleType, PlannerModel model) async {
    final String endpoint = 'planner/schedule/$scheduleType';
    final url = Uri.parse('$baseUrl/$endpoint');

    // API 요청 함수
    Future<http.Response> sendRequest(String token) async {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      // 디버깅 출력
      debugPrint('Request data: ${model.toJson()}');
      debugPrint('POST $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return response;
    }

    // 저장된 엑세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 엑세스 토큰이 만료된 경우(예: 401 Unauthorized)
    if (response.statusCode == 401) {
      try {
        // 리프레시 토큰을 사용해 엑세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }




  Future<http.Response> addReview(String reviewAt, ReviewModel model) async {
    final String endpoint = 'planner/daily/review/$reviewAt';
    final url = Uri.parse('$baseUrl/$endpoint');

    // 저장된 엑세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    // API 요청 함수
    Future<http.Response> sendRequest(String token) async {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
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

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 엑세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 401) {
      try {
        // 리프레시 토큰을 사용해 엑세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

 Future<http.Response> modifyReview(String reviewAt, String content) async {
    final url = Uri.parse('$baseUrl/planner/daily/review/$reviewAt');

    // 저장된 엑세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    // API 요청 함수
    Future<http.Response> sendRequest(String token) async {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'content': content}),
      );

      return response;
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 엑세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 401) {
      try {
        // 리프레시 토큰을 사용해 엑세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }


   Future<http.Response> findReview(String reviewAt) async {
    final url = Uri.parse('$baseUrl/planner/daily/review/$reviewAt');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    // API 요청 함수
    Future<http.Response> sendRequest(String token) async {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('GET $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return response;
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 액세스 토큰이 만료된 경우(예: 401 Unauthorized)
    if (response.statusCode == 401) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        // 새로운 액세스 토큰 저장
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken);

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

   Future<http.Response> findPlanner(ScheduleRequestModel requestModel) async {
    final formattedDate = formatDateTimeForJava(requestModel.scheduleDate);
    final url = Uri.parse('$baseUrl/planner/schdule/${requestModel.scheduleType}/$formattedDate');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    // API 요청 함수
    Future<http.Response> sendRequest(String token) async {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('GET $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return response;
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 액세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 401) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        // 새로운 액세스 토큰 저장
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken);

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  Future<http.Response> findTimeTable(TimeTableRequestModel requestModel) async {
    final formattedDate = formatDateTimeForJava(requestModel.scheduleDate);
    final url = Uri.parse('$baseUrl/planner/schdule/$formattedDate');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    // API 요청 함수
    Future<http.Response> sendRequest(String token) async {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('GET $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return response;
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 액세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 401) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        // 새로운 액세스 토큰 저장
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken);

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }



}
