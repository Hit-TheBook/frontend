import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project1/utils/refresh_token_api_helper.dart';

class AlertApiHelper {
  final String? baseUrl = dotenv.env['BASE_URL'];
  late FlutterSecureStorage storage;
  late RefreshTokenApiHelper refreshTokenHelper;

  AlertApiHelper() {
    storage = FlutterSecureStorage(); // FlutterSecureStorage 인스턴스 생성
    refreshTokenHelper = RefreshTokenApiHelper(); // 리프레시 토큰 헬퍼 인스턴스 생성
  }

  /// 공통 API 요청 함수
  Future<http.Response> _sendApiRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    // 저장된 액세스 토큰 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    Future<http.Response> sendRequest(String token) async {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      http.Response response;

      switch (method) {
        case 'POST':
          response = await http.post(url, headers: headers, body: jsonEncode(body));
          break;
        case 'PATCH':
          response = await http.patch(url, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      return response;
    }

    // API 호출 및 토큰 갱신 처리
    http.Response response = await sendRequest(accessToken);

    // 토큰 만료 처리 (499 상태)
    if (response.statusCode == 499) {
      try {
        final refreshTokenResponse = await refreshTokenHelper.refreshToken();
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  /// 알람 목록 가져오기
  Future<Map<String, List<Map<String, String>>>> getAlerts() async {
    final response = await _sendApiRequest(method: 'GET', endpoint: 'alert');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      return {
        "alertNoticeList": List<Map<String, String>>.from(
          jsonData["alertNoticeList"].map((item) => {
            "title": item["title"].toString(),
            "text": item["text"].toString(),
            "alertType": item["alertType"].toString(),
          }),
        ),
        "alertLevelEmblemList": List<Map<String, String>>.from(
          jsonData["alertLevelEmblemList"].map((item) => {
            "title": item["title"].toString(),
            "text": item["text"].toString(),
            "alertType": item["alertType"].toString(),
          }),
        ),
        "alertStudyList": List<Map<String, String>>.from(
          jsonData["alertStudyList"].map((item) => {
            "title": item["title"].toString(),
            "text": item["text"].toString(),
            "alertType": item["alertType"].toString(),
          }),
        ),
      };
    } else {
      throw Exception("Failed to load alerts");
    }
  }
}
