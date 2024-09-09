import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String baseUrl = 'http://13.209.78.125'; // 서버 URL을 지정하세요

  static Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);

    debugPrint('GET $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  static Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    debugPrint('POST $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  static Future<http.Response> putRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    debugPrint('PUT $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  static Future<http.Response> deleteRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url);

    debugPrint('DELETE $url');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return response;
  }

  static Future<Map<String, dynamic>> addDday(Map<String, dynamic> dday) async {
    final response = await postRequest('ddays', dday);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add Dday');
    }
  }

  static Future<Map<String, dynamic>> updateDday(String id, Map<String, dynamic> dday) async {
    final response = await putRequest('ddays/$id', dday);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update Dday');
    }
  }

  static Future<void> deleteDday(String id) async {
    final response = await deleteRequest('ddays/$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Dday');
    }
  }
}
