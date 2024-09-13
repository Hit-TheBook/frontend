import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project1/pages/ddaydetail_page.dart';
import 'package:project1/theme.dart';
import 'count_up_timer_page.dart';
import 'package:project1/widgets/custom_appbar.dart';
import 'package:project1/pages/main_page.dart'; // Import pages for navigation

class DdayPage extends StatefulWidget {
  const DdayPage({super.key});

  @override
  DdayPageState createState() => DdayPageState();
}

class DdayPageState extends State<DdayPage> {
  final List<Map<String, dynamic>> _ddayList = []; // 디데이 정보를 저장할 리스트
  Map<String, dynamic>? _selectedDday; // 현재 선택된 디데이 정보

  @override
  void initState() {
    super.initState();
    _fetchDdayList(); // 화면이 생성될 때 디데이 리스트를 가져옴
  }

  Future<void> _fetchDdayList() async {
    try {
      final response = await http.get(
        Uri.parse('http://13.209.78.125/dday/list'),
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0M0BleGFtcGxlLmNvbV85Mmlvc2RmOTNpc2Rmamkzb2kyMzRtb2ZzZGlqMiIsImlhdCI6MTcyNTk0NjQxOSwiZXhwIjoxNzU3NDgyNDE5fQ.t-LwL_f9huhSTzDMGLWLF_PAgqVq4NAk49kx1weMuFY1-eVY6OEBC1qm0rkmNyJAdIMylYtAuVq8Y8LS9IdUhQ', // 필요한 인증 정보를 추가합니다.
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final List<dynamic> upComingDdays = data['upComingDdays'] ?? [];
        final List<dynamic> oldDdays = data['oldDdays'] ?? [];

        setState(() {
          _ddayList.clear();
          _ddayList.addAll(upComingDdays.map((item) => {
            'title': item['ddayName'],
            'startDate': item['startDate'],
            'endDate': item['endDate'],
          }).toList());
        });

        // 성공적으로 디데이 리스트를 가져왔을 때 콘솔에 로그 출력
        print('디데이 리스트를 성공적으로 가져왔습니다: ${_ddayList.length}개의 디데이 항목이 있습니다.');
      } else {
        throw Exception('Failed to load dday list. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching dday list: $error');
    }
  }

  // 디데이 상세 페이지로 이동하는 함수
  void _navigateToDdayDetail() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DdaydetailPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _ddayList.add(result);
      });
    } else {
      print("Unexpected result type: $result");
    }
  }

  // 디데이 옵션(수정, 삭제 등)을 보여주는 함수
  void _showDdayOptions(BuildContext context, Map<String, dynamic> dday) {
    _selectedDday = dday;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333), // 배경색 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // 둥근 테두리
          ),
          contentPadding: EdgeInsets.zero, // Padding 제거
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // 화면 가로의 80%로 설정
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Text(
                    '대표 디데이 설정',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white), // 글씨색 흰색
                  ),
                  onTap: () {
                    Navigator.pop(context); // 다이얼로그 닫기
                    _setAsFeaturedDday(dday);
                  },
                ),
                ListTile(
                  title: const Text(
                    '디데이 정보 수정',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white), // 글씨색 흰색
                  ),
                  onTap: () {
                    Navigator.pop(context); // 다이얼로그 닫기
                    _editDdayInfo(dday);
                  },
                ),
                ListTile(
                  title: const Text(
                    '디데이 삭제',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white), // 글씨색 흰색
                  ),
                  onTap: () {
                    Navigator.pop(context); // 다이얼로그 닫기
                    _deleteDday(dday);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 대표 디데이 설정 함수
  void _setAsFeaturedDday(Map<String, dynamic> dday) {
    setState(() {
      _ddayList.remove(dday);
      _ddayList.insert(0, dday);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${dday['title']}이(가) 대표 디데이로 설정되었습니다.')),
    );
  }

  // 디데이 정보 수정 함수
  void _editDdayInfo(Map<String, dynamic> dday) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DdaydetailPage(
          initialTitle: dday['title'],
          initialStartDate: DateTime.parse(dday['startDate']),
          initialEndDate: DateTime.parse(dday['endDate']),
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final index = _ddayList.indexOf(dday);
        if (index != -1) {
          _ddayList[index] = result;
        }
      });
    }
  }

  // 디데이 삭제 함수
  void _deleteDday(Map<String, dynamic> dday) {
    setState(() {
      _ddayList.remove(dday);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${dday['title']}이(가) 삭제되었습니다.')),
    );
  }

  // 날짜 형식 포맷팅 함수
  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  // 시작일과 종료일의 차이를 계산하는 함수
  String _calculateDuration(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;
    return '$difference일';
  }

  // 시작일까지 남은 일수를 계산하는 함수
  String? _calculateDaysUntilStart(DateTime startDate) {
    final today = DateTime.now();
    final difference = startDate.difference(today).inDays;
    if (difference > 0) {
      return '$difference일 남음';
    }
    return null; // 오늘 날짜가 시작일을 지나면 null 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '디데이', // 사용할 타이틀을 전달
      ),
      body: _ddayList.isEmpty
          ? const Center(
        child: Text(
          '디데이를 추가해 보세요',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        itemCount: _ddayList.length,
        itemBuilder: (context, index) {
          final dday = _ddayList[index];
          final title = dday['title'] ?? '아아아';
          final startDate = DateTime.parse(dday['startDate']);
          final endDate = DateTime.parse(dday['endDate']);
          final formattedStartDate = _formatDate(startDate);
          final formattedEndDate = _formatDate(endDate);
          final duration = _calculateDuration(startDate, endDate);
          final daysUntilStart = _calculateDaysUntilStart(startDate);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333333), // 배경색
                borderRadius: BorderRadius.circular(16.0), // 둥근 테두리
              ),
              child: ElevatedButton(
                onPressed: () => _showDdayOptions(context, dday),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // 배경색 투명
                  elevation: 0, // 그림자 제거
                  minimumSize: const Size(double.infinity, 60), // 높이 조정
                  padding: EdgeInsets.zero, // Padding 제거
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 여백 추가
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold, // 글씨 굵게
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$formattedStartDate~$formattedEndDate ($duration)',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      if (daysUntilStart != null) // 오늘 날짜가 시작일을 지나지 않았다면
                        Text(
                          daysUntilStart,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToDdayDetail,
        backgroundColor: AppColors.primary,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
