import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/pages/ddaydetail_page.dart';
import 'package:project1/theme.dart';
import 'count_up_timer_page.dart';
import '../widgets/custom_appbar.dart';
import 'main_page.dart'; // Import pages for navigation

class DdayPage extends StatefulWidget {
  const DdayPage({super.key});

  @override
  DdayPageState createState() => DdayPageState();
}

class DdayPageState extends State<DdayPage> {
  final List<Map<String, dynamic>> _ddayList = []; // 디데이 정보를 저장할 리스트
  Map<String, dynamic>? _selectedDday; // 현재 선택된 디데이 정보

  void _navigateToDdayDetail() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DdaydetailPage()),
    );

    if (result != null) {
      setState(() {
        _ddayList.add(result);
      });
    }
  }

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
          content: Container(
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

  void _setAsFeaturedDday(Map<String, dynamic> dday) {
    setState(() {
      // 디데이를 리스트의 가장 위로 이동시킵니다.
      _ddayList.remove(dday);
      _ddayList.insert(0, dday);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${dday['title']}이(가) 대표 디데이로 설정되었습니다.')),
    );
  }

  void _editDdayInfo(Map<String, dynamic> dday) async {
    // 선택한 디데이 정보를 수정하기 위해 DdaydetailPage를 열고 결과를 받습니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DdaydetailPage(
          initialTitle: dday['title'],
          initialStartDate: dday['startDate'],
          initialEndDate: dday['endDate'],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        // 기존 디데이 정보를 수정합니다.
        final index = _ddayList.indexOf(dday);
        if (index != -1) {
          _ddayList[index] = result;
        }
      });
    }
  }

  void _deleteDday(Map<String, dynamic> dday) {
    setState(() {
      _ddayList.remove(dday);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${dday['title']}이(가) 삭제되었습니다.')),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  String _calculateDuration(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;
    return '$difference일';
  }

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
          final title = dday['title'] ?? '디데이 제목';
          final startDate = dday['startDate'] != null
              ? DateTime.parse(dday['startDate'].toString())
              : null;
          final endDate = dday['endDate'] != null
              ? DateTime.parse(dday['endDate'].toString())
              : null;
          final formattedStartDate = startDate != null
              ? _formatDate(startDate)
              : '시작일 없음';
          final formattedEndDate = endDate != null
              ? _formatDate(endDate)
              : '종료일 없음';
          final duration = (startDate != null && endDate != null)
              ? _calculateDuration(startDate, endDate)
              : '';
          final daysUntilStart = (startDate != null)
              ? _calculateDaysUntilStart(startDate)
              : null;

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
