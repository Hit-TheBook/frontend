import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'refresh_token_api_helper.dart';
import 'package:project1/models/timer_model.dart';


class TimerApiHelper {
  final String baseUrl = 'http://13.209.78.125';
  final FlutterSecureStorage storage = FlutterSecureStorage(); // FlutterSecureStorage 인스턴스 생성
  final RefreshTokenApiHelper refreshTokenHelper = RefreshTokenApiHelper(); // 리프레시 토큰 헬퍼 인스턴스 생성

  Duration convertToDuration(String iso8601String) {
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');  // "PT2H22M52S"와 "PT22M52S" 모두 처리
    final match = regex.firstMatch(iso8601String);

    if (match != null) {
      final hours = match.group(1) != null ? int.parse(match.group(1)!.replaceAll('H', '')) : 0;
      final minutes = match.group(2) != null ? int.parse(match.group(2)!.replaceAll('M', '')) : 0;
      final seconds = match.group(3) != null ? int.parse(match.group(3)!.replaceAll('S', '')) : 0;
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      throw FormatException('Invalid duration format');
    }
  }



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
          response = await http.post(url, headers: headers, body: jsonEncode(body));
          break;
        case 'PATCH':
          debugPrint('PATCH Request:');
          debugPrint('URL: $url');
          debugPrint('Headers: $headers');
          debugPrint('Body: ${jsonEncode(body)}');
          response = await http.patch(url, headers: headers, body: jsonEncode(body));
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

  // 과목 추가
  Future<http.Response> addSubject(String subjectName) async {
    return await _sendApiRequest(
      method: 'POST',
      endpoint: 'timer/$subjectName', // Path Variable에 subjectName 포함
    );
  }


  // 과목 수정
  Future<http.Response> modifySubject(int timerId,String subjectName) async {
    return await _sendApiRequest(
      method: 'PATCH',
      endpoint: 'timer/$timerId/$subjectName',
      //body: request.toJson(),
    );
  }

  // 과목 삭제
  Future<bool> deleteTimer(int timerId) async {
    final response = await _sendApiRequest(
      method: 'DELETE',
      endpoint: 'timer/$timerId',
    );

    if (response.statusCode == 200) {
      print('과목 삭제 성공');
      return true;
    } else {
      print('삭제 실패: ${response.body}');
      return false;
    }
  }
  // Future<List<TimerSubjectRequest>> fetchTimerContentList() async {
  //   final response = await _sendApiRequest(
  //     method: 'GET',
  //     endpoint: 'timerContentList',
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // JSON 파싱
  //     final Map<String, dynamic> jsonData = json.decode(response.body);
  //
  //     // timerContentList 데이터를 리스트로 변환
  //     final List<dynamic> timerContentList = jsonData['timerContentList'];
  //
  //     // 각 데이터를 TimerSubjectRequest 객체로 변환
  //     return timerContentList
  //         .map((item) => TimerSubjectRequest.fromJson(item))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to fetch timer content: ${response.body}');
  //   }
  // }

  Future<List<Map<String, dynamic>>> getTimerList() async {
    final response = await _sendApiRequest(
      method: 'GET',
      endpoint: 'timer/list', // 실제 API endpoint에 맞게 수정
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // timerContentList가 존재하는지 확인
      if (jsonData.containsKey('timerContentList')) {
        final List<dynamic> timerContentList = jsonData['timerContentList'];

        // 각 항목에 대해 totalStudyTime을 Duration으로 변환
        return timerContentList.map((entry) {
          // totalStudyTime을 Duration으로 변환
          final totalDuration = convertToDuration(entry['totalStudyTime']);

          // 변환된 값을 포함한 새로운 데이터 구조 반환
          return {

            'timerId': entry['timerId'],
            'subjectName': entry['subjectName'],
            'totalStudyTime': totalDuration, // Duration 값 포함
            'totalScore': entry['totalScore'],
          };
        }).toList();
      } else {
        throw Exception('Invalid response structure');
      }
    } else {
      throw Exception('Failed to load timer list');
    }
  }
  // 타이머 종료
  Future<http.Response> endTimer(int timerId,TimerEndRequest request) async {
    return await _sendApiRequest(
      method: 'POST',
      endpoint: 'timer/history/$timerId',
      body: request.toJson(),
    );
  }


}
