import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import 'refresh_token_api_helper.dart';

class AuthApiHelper {
  final String baseUrl = 'http://13.209.78.125';
  final FlutterSecureStorage storage = FlutterSecureStorage(); // FlutterSecureStorage 인스턴스 생성
  final RefreshTokenApiHelper refreshTokenHelper = RefreshTokenApiHelper(); // 리프레시 토큰 헬퍼 인스턴스 생성


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

  Future<bool> registerUser(String email, String password,
      String nickname) async {
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


  Future<http.Response> checkPreviousPassword(String email,
      String password) async {
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

  // DELETE 요청
  Future<http.Response> deleteAccount(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

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
        await storage.write(key: 'accessToken',
            value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  Future<http.Response> findUserName(String endpoint) async {
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
        await storage.write(key: 'accessToken',
            value: refreshTokenResponse.accessToken); // 새로운 토큰 저장

        // 새로운 토큰으로 API 요청 다시 시도
        response = await sendRequest(refreshTokenResponse.accessToken);
      } catch (e) {
        throw Exception('Failed to refresh token: $e');
      }
    }

    return response;
  }

  // Future<bool> checkNicknameAvailability(String nickname) async {
  //   final url = Uri.parse('$baseUrl/member/nickname/check'); // 실제 API 주소로 변경
  //
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({'nickname': nickname}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // 서버 응답이 200일 때 처리 (중복되지 않음)
  //       var data = json.decode(response.body);
  //       return data['available'] == true; // 'available'이 true이면 사용 가능
  //     } else {
  //       // 오류 처리
  //       throw Exception('닉네임 중복 확인 실패');
  //     }
  //   } catch (e) {
  //     // 예외 처리
  //     print('Error: $e');
  //     return false; // 실패 시 false 반환
  //   }
  // }

  // 공통 API 요청 함수
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
          debugPrint('POST Request:');
          debugPrint('URL: $url');
          debugPrint('Headers: $headers');
          debugPrint('Body: ${jsonEncode(body)}');
          response =
          await http.post(url, headers: headers, body: jsonEncode(body));
          break;
        case 'PATCH':
          debugPrint('PATCH Request:');
          debugPrint('URL: $url');
          debugPrint('Headers: $headers');
          debugPrint('Body: ${jsonEncode(body)}');
          response =
          await http.patch(url, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          debugPrint('DELETE Request:');
          debugPrint('URL: $url');
          debugPrint('Headers: $headers');
          response = await http.delete(url, headers: headers);
          break;
        case 'GET': // 추가된 부분: GET 메소드 처리
          debugPrint('GET Request:');
          debugPrint('URL: $url');
          debugPrint('Headers: $headers');
          response = await http.get(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // 응답 디버그 출력
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

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

  Future<List<Emblem>> fetchEmblems() async {
    try {
      // API 호출
      final response = await _sendApiRequest(
        method: 'GET',
        endpoint: 'member/emblem', // 엠블럼 API 엔드포인트
      );

      if (response.statusCode == 200) {
        // 서버 응답을 JSON으로 파싱
        List<dynamic> data = jsonDecode(response.body)['emblemDtoContents'];
        // 데이터 파싱
        List<Emblem> emblems = data.map((item) => Emblem.fromJson(item))
            .toList();

        // 필요 없는 추가 리스트는 제거하고 바로 반환
        return emblems;
      } else {
        throw Exception('엠블럼 데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('엠블럼 데이터를 가져오는 중 오류 발생: $e');
      throw e;
    }
  }

  Future<Level> fetchLevel() async {
    try {
      // API 호출
      final response = await _sendApiRequest(
        method: 'GET',
        endpoint: 'member/level', // 레벨 API 엔드포인트
      );

      if (response.statusCode == 200) {
        // 서버 응답을 JSON으로 파싱
        var data = jsonDecode(response.body); // 단일 객체 반환
        // 데이터 파싱
        Level level = Level.fromJson(data); // 단일 객체로 변환

        return level; // Level 객체 반환
      } else {
        throw Exception('레벨 데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('레벨 데이터를 가져오는 중 오류 발생: $e');
      throw e;
    }
  }
  Future<bool> checkNicknameAvailability(String nickname) async {
    final response = await _sendApiRequest(
      method: 'POST',
      endpoint: 'member/nickname/check/$nickname', // 요청 URL
      body: {'nickname': nickname}, // 요청 본문
    );

    if (response.statusCode == 200) {
      return true; // 사용 가능한 닉네임
    } else {
      return false; // 사용 불가능한 닉네임
    }
  }


}