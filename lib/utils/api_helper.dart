import 'package:http/http.dart' as http;
import 'dart:convert';

class DdayApiHelper {
  final String baseUrl;

  DdayApiHelper(this.baseUrl);

  // 전체 Dday 목록 가져오기
  Future<List<Map<String, dynamic>>> fetchDdayList() async {
    final response = await http.get(Uri.parse('$baseUrl/dday/list'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load Ddays');
    }
  }

  // Dday 추가하기
  Future<void> addDday(Map<String, dynamic> dday) async {
    final response = await http.post(
      Uri.parse('$baseUrl/dday'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(dday),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add Dday');
    }
  }

  // Dday 수정하기
  Future<void> updateDday(String ddayId, Map<String, dynamic> dday) async {
    final response = await http.put(
      Uri.parse('$baseUrl/dday/$ddayId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(dday),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Dday');
    }
  }

  // Dday 삭제하기
  Future<void> deleteDday(String ddayId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/dday/$ddayId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Dday');
    }
  }

  // 대표 Dday 등록하기
  Future<void> setPrimaryDday(String ddayId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/dday/primary/$ddayId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set primary Dday');
    }
  }

  // 대표 Dday 가져오기
  Future<Map<String, dynamic>> fetchPrimaryDday() async {
    final response = await http.get(Uri.parse('$baseUrl/dday/primary'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load primary Dday');
    }
  }
}
