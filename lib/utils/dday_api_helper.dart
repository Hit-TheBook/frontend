import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'refresh_token_api_helper.dart'; // 리프레시 토큰 헬퍼를 임포트

class ApiHelper {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final FlutterSecureStorage storage = FlutterSecureStorage(); // FlutterSecureStorage 인스턴스 생성
  final RefreshTokenApiHelper refreshTokenHelper = RefreshTokenApiHelper(); // 리프레시 토큰 헬퍼 인스턴스 생성

  // GET 요청
  Future<http.Response> findDdayList(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    Future<http.Response> sendRequest(String token) async {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // 헤더에 토큰 추가
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
    if (response.statusCode == 499) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  // POST 요청
 Future<http.Response> addDday(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    Future<http.Response> sendRequest(String token) async {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // 헤더에 토큰 추가
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

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 액세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 499) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  // PUT 요청
  Future<http.Response> modifyDday(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/dday/$endpoint');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    Future<http.Response> sendRequest(String token) async {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // 헤더에 토큰 추가
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      debugPrint('PUT $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return response;
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 액세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 499) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  // DELETE 요청
 Future<http.Response> deleteDday(String endpoint) async {
    final url = Uri.parse('$baseUrl/dday/$endpoint');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    Future<http.Response> sendRequest(String token) async {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token', // 헤더에 토큰 추가
          'Content-Type': 'application/json',
        },
      );

      debugPrint('DELETE $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return response;
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 액세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 499) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  // 대표 디데이 설정
  Future<http.Response> setFeaturedDday(String ddayId) async {
    final url = Uri.parse('$baseUrl/dday/primary/$ddayId');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    Future<http.Response> sendRequest(String token) async {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // 헤더에 토큰 추가
          'Content-Type': 'application/json',
        },
        body: jsonEncode(ddayId), // RequestDday 객체를 JSON 문자열로 변환
      );

      debugPrint('POST $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return response;
    }

    // API 호출 및 응답 처리
    http.Response response = await sendRequest(accessToken);

    // 액세스 토큰이 만료된 경우(401 Unauthorized)
    if (response.statusCode == 499) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  // 대표 디데이 get
   Future<http.Response> fetchDdayList(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    Future<http.Response> sendRequest(String token) async {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // 헤더에 토큰 추가
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
    if (response.statusCode == 499) {
      try {
        // 리프레시 토큰을 사용해 액세스 토큰 갱신
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        await storage.write(key: 'accessToken', value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }
}
